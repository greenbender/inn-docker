```
docker build -t inn .
docker run --rm -p119:119 -p563:563 inn
-- or --
docker run --rm -p119:119 -p563:563 greenbender/inn
```
INN's log messages (innd and nnrpd) appear in `docker logs`. Run INN admin
commands as the news user, e.g. `docker exec -u news <container> ctlinnd mode`.
To use this in a GitHub Action please add:
```yaml
    services:
      inn-service:
        image: greenbender/inn
        ports:
          - 119:119
          - 563:563
```
* https://github.com/greenbender/inn-docker
* https://hub.docker.com/r/greenbender/inn/tags
