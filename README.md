# express-app
Simple dockerized Node.js app

## 0. Pre-requirements

* `docker` installed on your sandbox (or any other Linux machine), make sure `docker info` works
* this repository cloned on your local machine

## 1. A single container

### Build it

```
docker build -t macbre/express-app .
```

### Ways to run the container

```
docker run macbre/express-app
```

But wait, we can't reach the container even though it's running (`docker ps`).

```
docker run -p 8000:3000 macbre/express-app
```

```
$ curl -i 0:8000
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 12
ETag: W/"c-Lve95gjOVATpfV8EL5X4nxwjKHE"
Date: Fri, 22 Oct 2021 12:03:13 GMT
Connection: keep-alive
Keep-Alive: timeout=5
```

Now, stopped containers are still there. Let's make sure they're removed once they exit.

### Running it permanently

```
docker run -d -p 8000:3000 --rm --name express-app macbre/express-app
```

```
$ docker ps
CONTAINER ID   IMAGE                     COMMAND                  CREATED         STATUS                PORTS                                                                                                NAMES
561fb5bffcf9   macbre/express-app        "docker-entrypoint.s…"   4 seconds ago   Up 2 seconds          0.0.0.0:8000->3000/tcp                                                                               express-app
```

```
$ docker logs -f express-app

> express-app@1.0.0 start
> node app.js

Example app listening at http://localhost:3000
GET / 304 - - 18.661 ms
```

### Signals handling

```
$ docker run --rm -p 8000:3000 --name express-app macbre/express-app

> express-app@1.0.0 start
> node app.js

Example app listening at http://localhost:3000

# docker stop express-app
Got SIGTERM signal
```

## 2. Docker compose

```
docker compose pull && docker compose build
docker compose up
```

Checking the state of containers:

```
$ docker compose ps
NAME                  COMMAND                  SERVICE             STATUS              PORTS
express-app-app-1     "docker-entrypoint.s…"   app                 running (healthy)   0.0.0.0:8000->3000/tcp
express-app-nginx-1   "nginx -g 'daemon of…"   nginx               running             0.0.0.0:8888->80/tcp
```

Logs:

```
$ docker compose logs -f app
express-app-app-1  | 
express-app-app-1  | > express-app@1.0.0 start
express-app-app-1  | > node app.js
express-app-app-1  | 
express-app-app-1  | Example app listening at http://localhost:3000
express-app-app-1  | ::ffff:172.19.0.1 - - [22/Oct/2021:14:46:50 +0000] "GET / HTTP/1.1" 200 13
express-app-app-1  | ::ffff:127.0.0.1 - - [22/Oct/2021:14:47:14 +0000] "GET / HTTP/1.1" 200 13
express-app-app-1  | ::ffff:127.0.0.1 - - [22/Oct/2021:14:47:44 +0000] "GET / HTTP/1.1" 200 13
```

```
$ curl 0:8888 -s
Hello World!
(...)
express-app-nginx-1  | 172.19.0.1 - - [22/Oct/2021:15:34:09 +0000] "GET / HTTP/1.1" 200 13 "-" "curl/7.64.1" "-"
express-app-app-1    | ::ffff:172.19.0.3 - - [22/Oct/2021:15:34:09 +0000] "GET / HTTP/1.0" 200 13
```

Resources usage information:

```
$ docker stats
CONTAINER ID   NAME                  CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O     PIDS
4fd13135af2f   express-app-nginx-1   0.00%     1.543MiB / 16MiB      9.64%     908B / 0B         0B / 4.1kB    2
ec150fb08582   express-app-app-1     0.01%     26.27MiB / 64MiB      41.05%    1.61kB / 554B     0B / 0B       18
```

Executing commands from inside the running container:

```
$ docker exec -it express-app-app-1 sh
/app # ping -c1 nginx
PING nginx (172.19.0.3): 56 data bytes
64 bytes from 172.19.0.3: seq=0 ttl=64 time=0.629 ms
(...)
/app # wget nginx -O /dev/stdout -q
Hello World!
```

And logs:

```
express-app-nginx-1  | 172.19.0.2 - - [22/Oct/2021:14:58:25 +0000] "GET / HTTP/1.1" 200 13 "-" "Wget" "-"
express-app-app-1    | ::ffff:172.19.0.3 - - [22/Oct/2021:14:58:25 +0000] "GET / HTTP/1.0" 200 13
```
