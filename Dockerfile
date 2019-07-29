FROM openjdk:8

MAINTAINER Dalton Jorge <daltonjorge@gmail.com>

ENV SDKMAN_DIR /usr/local/sdkman
ENV SDKMAN_URL https://get.sdkman.io
ENV SONAR_VERSION 4.0.0.1744-linux
ENV SONAR_ZIP sonar-scanner-cli-${SONAR_VERSION}.zip
ENV SONAR_APP sonar-scanner-${SONAR_VERSION}
ENV SONAR_DIR /opt/sonarscanner
ENV SONAR_URL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli
ENV CERTIFICATE_DIR /usr/local/share/ca-certificates
ENV CERTIFICATE_URL https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt
ENV CERTIFICATE_FILE letsencryptauthorityx3.crt

# System update and install utilities
RUN set -x && \
    apt-get update && apt-get install -y \
      ca-certificates \
      zip \
      unzip \
      curl \
      sshpass && \
    rm -rf /var/lib/apt/lists/*

# Set certificates directory as working directory
WORKDIR $CERTIFICATE_DIR

# Download and install Let's Encrypt root certificate
RUN mkdir letsencrypt.org && \
    cd letsencrypt.org/ && \
    wget -O $CERTIFICATE_FILE $CERTIFICATE_URL && \
    update-ca-certificates

# Set root directory as working directory
WORKDIR /root

# Download and install sonar-scaner
RUN mkdir $SONAR_DIR && \
    cd $SONAR_DIR && \
    curl -O ${SONAR_URL}/${SONAR_ZIP} && \
    unzip $SONAR_ZIP && \
    rm $SONAR_ZIP && \
    chmod +x ${SONAR_APP}/bin/sonar-scanner && \
    ln -s ${SONAR_DIR}/${SONAR_APP}/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Download, install and set options for SDKMAN!
RUN curl -s $SDKMAN_URL | bash && \
    echo "sdkman_auto_answer=true" > ${SDKMAN_DIR}/etc/config && \
    echo "sdkman_auto_selfupdate=false" >> ${SDKMAN_DIR}/etc/config && \
    echo "sdkman_insecure_ssl=false" >> ${SDKMAN_DIR}/etc/config

# Set SDKMAN! installation directory as working directory
WORKDIR $SDKMAN_DIR

# Copy initialisation snippet file from docker host
COPY entrypoint.sh /

# Turn initialisation snippet file to executable
RUN chmod +x /entrypoint.sh

# Set initialisation snippet file as entrypoint for docker image
ENTRYPOINT ["/entrypoint.sh"]
