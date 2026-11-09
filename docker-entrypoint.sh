#!/bin/sh

# Started as root (the default): send INN's syslog messages (innd and nnrpd)
# to the container's stdout, then run INN as the news user. Only root can
# create /dev/log; started as another user, INN runs without syslog. Use
# "docker exec -u news" for INN admin commands.
if [ "$(id -u)" = 0 ]; then
	syslogd -n -O - &
	exec su-exec news "$0" "$@"
fi

if [ ! -f etc/key.pem ]; then
	echo "Generating SSL key"
	openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -quiet \
		-keyout etc/key.pem -out etc/cert.pem -subj "/CN=news.localhost"
fi

. lib/innshellvars

echo "Starting $(innconfval -v)"

# Support for implicit TLS
nnrpd -D -p 563 -S

# innd has no handler for SIGTERM (ignored) or SIGINT (killed without
# flushing its databases), so turn docker stop and Ctrl-C into a clean
# ctlinnd shutdown, then wait for innd to exit.
innd "$@" &
innd_pid=$!
trap 'ctlinnd -t 20 shutdown "container stopping" >/dev/null' TERM INT
while kill -0 "$innd_pid" 2>/dev/null; do
	wait "$innd_pid"
done
