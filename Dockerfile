FROM azul/zulu-openjdk:latest

MAINTAINER Dalton Jorge <daltonjorge@gmail.com>

ENV SDKMAN_DIR /usr/local/sdkman

RUN apt-get update && \
    apt-get install -y zip unzip curl && \
    apt-get clean

RUN curl -s "https://get.sdkman.io" | bash

RUN set -x && \
    echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config && \
    echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config && \
    echo "sdkman_insecure_ssl=false" >> $SDKMAN_DIR/etc/config

WORKDIR $SDKMAN_DIR

#COPY docker-entrypoint.sh /

ENTRYPOINT ["[[ -s \"$SDKMAN_DIR/bin/sdkman-init.sh\" ]] && source \"$SDKMAN_DIR/bin/sdkman-init.sh\" && exec \"$@\""]