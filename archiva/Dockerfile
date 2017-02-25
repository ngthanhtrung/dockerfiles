FROM openjdk:8u111-jre

MAINTAINER Trung Nguyen <i@ngthanhtrung.com>

RUN groupadd -r archiva && useradd -r -g archiva archiva

ENV ARCHIVA_VERSION 2.2.1
ENV ARCHIVA_BIN_URL http://www.apache.org/dist/archiva/$ARCHIVA_VERSION/binaries/apache-archiva-$ARCHIVA_VERSION-bin.tar.gz
ENV ARCHIVA_BIN_MD5 ff4a83007ac10fe4add308d22dfbc3d6
ENV ARCHIVA_BASE /var/archiva

RUN curl -sSLo archiva.tar.gz $ARCHIVA_BIN_URL \
	&& echo "$ARCHIVA_BIN_MD5 archiva.tar.gz" | md5sum -c \
	&& tar -xf archiva.tar.gz -C /usr/local \
	&& mv /usr/local/apache-archiva-$ARCHIVA_VERSION /usr/local/archiva \
	&& rm archiva.tar.gz \
	\
	&& mkdir -p \
		$ARCHIVA_BASE/conf \
		$ARCHIVA_BASE/data \
		$ARCHIVA_BASE/logs \
		$ARCHIVA_BASE/temp \
	\
	&& cd /usr/local/archiva \
	&& sed -i "/set.default.ARCHIVA_BASE/c\set.default.ARCHIVA_BASE=$ARCHIVA_BASE" conf/wrapper.conf \
	&& mv conf/* $ARCHIVA_BASE/conf \
	&& rmdir conf logs temp \
	&& ln -s $ARCHIVA_BASE/conf conf \
	&& ln -s $ARCHIVA_BASE/data data \
	&& ln -s $ARCHIVA_BASE/logs logs \
	&& ln -s $ARCHIVA_BASE/temp temp \
	\
	&& chown -R archiva:archiva $ARCHIVA_BASE

VOLUME /var/archiva
USER archiva
WORKDIR /usr/local/archiva

EXPOSE 8080
CMD [ "bin/archiva", "console" ]
