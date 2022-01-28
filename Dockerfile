FROM openjdk:8-jre-alpine

# Define the version of OpenJDK we want
ENV JAVA_VERSION 8u275
ENV JAVA_ALPINE_VERSION 8.275.01-r0

# Metadata
LABEL module.maintainer="onesaitplatform@indra.es" \
	  module.name="cliente-service"
	  
RUN apk update
RUN apk upgrade
# RUN apk upgrade busybox --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main	

# Install openjdk-8
# Add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

RUN set -x \
	&& apk add --no-cache openjdk8-jre="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]


# Ajustar timezone del contenedor
RUN apk add --no-cache tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime

