FROM ubuntu:20.04                                               
# COPY index.html /usr/local/tomcat/webapps/ROOT/index.html
# FROM busybox

LABEL Description="This image provides a base environment for testing automation mobile app with gradle."

# set default build arguments
ARG GRADLE_VERSION=7.1
ARG JAVA_VERSION=11.0.13-zulu

# set default environment variables
ENV SDKMAN_DIR /root/.sdkman

# Install system dependencies
RUN apt-get update && apt-get install -y zip curl
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN curl -s "https://get.sdkman.io" | bash
RUN chmod a+x "$SDKMAN_DIR/bin/sdkman-init.sh"

RUN set -x \
    && echo "sdkman_auto_answer=true" > $SDKMAN_DIR/etc/config \
    && echo "sdkman_auto_selfupdate=false" >> $SDKMAN_DIR/etc/config \
    && echo "sdkman_insecure_ssl=false" >> $SDKMAN_DIR/etc/config

WORKDIR $SDKMAN_DIR
RUN [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh" && exec "$@"

RUN source /root/.bashrc
RUN source "$SDKMAN_DIR/bin/sdkman-init.sh" && sdk install java $JAVA_VERSION
RUN source "$SDKMAN_DIR/bin/sdkman-init.sh" && sdk install gradle $GRADLE_VERSION

