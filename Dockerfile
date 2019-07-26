FROM openjdk:8

MAINTAINER Dalton Jorge <daltonjorge@gmail.com>

ENV SDKMAN_DIR /usr/local/sdkman
ENV SONAR_ZIP sonar-scanner-cli-4.0.0.1744-linux.zip
ENV SONAR_APP sonar-scanner-4.0.0.1744-linux
ENV SONAR_DIR /opt/sonarscanner
ENV SONAR_URL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli

RUN apt-get update && \
    apt-get install -y ca-certificates zip unzip curl && \
    apt-get clean

RUN curl -s "https://get.sdkman.io" | bash

RUN mkdir $SONAR_DIR && \
    cd $SONAR_DIR && \
    curl -O "$SONAR_URL/$SONAR_ZIP" && \
    unzip "$SONAR_ZIP" && \
    rm $SONAR_ZIP && \
    chmod +x $SONAR_APP/bin/sonar-scanner && \
    ln -s $SONAR_DIR/$SONAR_APP/bin/sonar-scanner /usr/local/bin/sonar-scanner

RUN set -x && \
    echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config && \
    echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config && \
    echo "sdkman_insecure_ssl=false" >> $SDKMAN_DIR/etc/config

WORKDIR $SDKMAN_DIR

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
