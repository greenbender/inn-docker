```
docker build -t inn .
docker run --rm -t -p119:119  -p563:563 inn
-- or --
docker run --rm -t -p119:119 -p563:563 greenbender/inn
```
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
