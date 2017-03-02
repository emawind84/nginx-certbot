FROM nginx
MAINTAINER Emanuele Disco <emanuele.disco@gmail.com>

RUN apt-get update && apt-get -y install \
    wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN set -xe \
    && wget https://dl.eff.org/certbot-auto \
    && chmod a+x /certbot-auto \
    && /bin/sh certbot-auto --quiet --os-packages-only

COPY ./docker-entrypoint.sh ./entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]