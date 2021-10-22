# express-app
Simple dockerized Node.js app

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
