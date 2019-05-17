# X-Trace Server

Standalone X-Trace server

To run the X-Trace server:

```
xtrace-server/bin/backend
```

## Web Interface

The web interface can be accessed on port 4080, e.g. http://localhost:4080

## Configuration

X-Trace server configuration lives in `xtrace-server/etc/application.conf`

## Docker

The provided Dockerfile builds a docker image, e.g.

```
docker build --rm=true -t jonathanmace/xtrace-server docker
```

For the X-Trace server to be accessible to other docker containers, you must expose ports 4080, and 5563.  4080 is for the web interface; 5563 receives reports from X-Trace clients.

For example:

```
docker run -ti -w /home/ -p 4080:4080 -p 5563:5563 -p 5564:5564 --name xtrace-server --hostname xtrace-server --network dockercompose_default jonathanmace/xtrace
```