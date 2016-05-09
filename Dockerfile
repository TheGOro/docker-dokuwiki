FROM ubuntu:15.10
MAINTAINER David Sauer <info@suchgenie.de>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && \
    apt-get install -y nginx php5-fpm php5-gd curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*
ADD dokuwiki.conf /etc/nginx/sites-enabled/

EXPOSE 80
VOLUME [ \
    "/var/www/data/", \
    "/var/www/lib/tpl", \
    "/var/www/lib/plugins", \
    "/var/www/conf" \
]

CMD /usr/sbin/php5-fpm && /usr/sbin/nginx

ENV DOKUWIKI_VERSION 2015-08-10a

RUN mkdir -p /var/www
RUN cd /var/www && curl http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz | tar xz --strip 1
RUN chown -R www-data:www-data /var/www
