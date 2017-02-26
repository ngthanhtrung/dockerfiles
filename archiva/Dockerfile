FROM openjdk:8-jre

MAINTAINER Trung Nguyen <i@ngthanhtrung.com>

RUN groupadd -r archiva && useradd -r -g archiva archiva

ENV GOSU_VERSION 1.7

RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "${GNUPGHOME}" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

ENV ARCHIVA_VERSION 2.2.1

RUN set -x \
	&& wget -O archiva.tar.gz "https://www.apache.org/dist/archiva/${ARCHIVA_VERSION}/binaries/apache-archiva-${ARCHIVA_VERSION}-bin.tar.gz" \
	&& wget -O archiva.tar.gz.asc "https://www.apache.org/dist/archiva/${ARCHIVA_VERSION}/binaries/apache-archiva-${ARCHIVA_VERSION}-bin.tar.gz.asc" \
	&& wget -O KEYS https://www.apache.org/dist/archiva/KEYS \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --import KEYS \
	&& gpg --batch --verify archiva.tar.gz.asc archiva.tar.gz \
	&& rm -r "${GNUPGHOME}" KEYS archiva.tar.gz.asc \
	\
	&& tar -xf archiva.tar.gz -C /usr/local \
	&& mv "/usr/local/apache-archiva-${ARCHIVA_VERSION}" /usr/local/archiva \
	&& rm archiva.tar.gz \
	\
	&& mkdir -p /var/lib/archiva \
	&& mv /usr/local/archiva/conf /var/lib/archiva \
	&& ln -s /var/lib/archiva/conf /usr/local/archiva/conf \
	&& rm -r /usr/local/archiva/logs /usr/local/archiva/temp \
	&& for dir in \
		data \
		logs \
		repositories \
		temp \
	; do \
		mkdir -p "/var/lib/archiva/${dir}"; \
		ln -s "/var/lib/archiva/${dir}" "/usr/local/archiva/${dir}"; \
	done \
	&& chown -R archiva:archiva /var/lib/archiva

ENV PATH /usr/local/archiva/bin:$PATH

WORKDIR /var/lib/archiva

VOLUME /var/lib/archiva/data
VOLUME /var/lib/archiva/repositories

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8080
CMD ["archiva", "console"]
