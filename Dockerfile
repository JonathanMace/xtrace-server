FROM java:9

MAINTAINER Jonathan Mace <jonathan.c.mace@gmail.com>

# install needed packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      daemon \
  && rm -rf /var/lib/apt/lists/*

# copy pre-built xtrace-server from host
ADD xtrace-server /home/xtrace-server

#set environment variables
ENV XTRACE_BACKEND /home/xtrace-server/bin/backend

# copy to WD
#ADD start-xtrace.sh /home/

# startup command
CMD chmod +x $XTRACE_BACKEND && \
    echo "[INFO] Starting X-Trace docker server" && \
    $XTRACE_BACKEND


#sh /home/start-xtrace.sh