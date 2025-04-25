#!/bin/sh

# $HOSTNAME should be "inn-server-a" or "inn-server-b"
echo $HOSTNAME

cat /inn_config/$HOSTNAME/etc_incoming.conf >> etc/incoming.conf
cat /inn_config/$HOSTNAME/etc_innfeed.conf >> etc/innfeed.conf
cat /inn_config/$HOSTNAME/etc_newsfeeds >> etc/newsfeeds

ctlinnd newgroup my.public
tail etc/incoming.conf etc/innfeed.conf etc/newsfeeds db/active

ctlinnd reload '' 'Reload configuration files'
innfeed -C
# innfeed  # --> Segmentation fault
