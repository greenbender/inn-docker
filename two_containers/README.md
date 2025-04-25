# Can we sync news between two Docker-based INN servers?

Get two Docker-based INN servers up and running.
```sh
docker compose up --build
```
You can log into the containers in ___separate terminal tabs___ with:
```sh
docker exec -it inn-server-a sh
docker exec -it inn-server-b sh
```
Ensure that the Docker network allows bidirectional communications.
```sh
docker exec -it inn-server-a ping -c 2 inn-server-b
docker exec -it inn-server-b ping -c 2 inn-server-a
```
Add config to the end of `etc/incoming.conf`, `etc/innfeed.conf`, and `etc/newsfeeds`.
Create a `my.public` newsgroup and tail key files.
Run `ctlinnd reload '' 'Reload configuration files'`
```sh
docker exec -it inn-server-a /inn_config/create_newsgroups.sh
docker exec -it inn-server-b /inn_config/create_newsgroups.sh
```
Add a few news articles to inn-server-a newsgroups and verify their presence with:
```sh
docker exec -it inn-server-a cat db/active
```
Check to see if the articles have been synced over to inn-server-b.
```sh
docker exec -it inn-server-b cat db/active
```
This will say that the config file is OK.
```sh
docker exec -it inn-server-a innfeed -C
```
This will generate a Segmentation fault!
```sh
docker exec -it inn-server-a innfeed
```
## ___Unfortunately___ the articles are never synced between the two servers.
