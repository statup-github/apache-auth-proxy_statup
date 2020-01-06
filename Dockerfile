FROM stefanfritsch/baseimage_statup:1.1.20200104
LABEL org.opencontainers.image.created="2020-01-04T14:39:06Z"
LABEL maintainer="Stefan Fritsch <stefan.fritsch@stat-up.com>"

EXPOSE 80
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
          apache2 \
          libapache2-mod-auth-openidc \
          net-tools \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV UPSTREAM shiny.stat-up.com
ENV PORT 80
ENV BASEDIR /
ENV ADMIN_EMAIL it@stat-up.com

COPY index.html /var/www/html/auth/index.html
COPY style.css /var/www/html/auth/css/style.css
COPY httpd.conf /etc/apache2/apache2.conf

RUN  mkdir /etc/service/apache
COPY apache.sh /etc/service/apache/run
RUN chmod 0500 /etc/service/apache/run
