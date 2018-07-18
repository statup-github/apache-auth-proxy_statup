FROM httpd:2.4
LABEL maintainer="Stefan Fritsch <stefan.fritsch@stat-up.com>"

EXPOSE 80

RUN apt-get update && apt-get install nano && apt-get clean

ENV UPSTREAM shiny.stat-up.com
ENV PORT 80
ENV BASEDIR /

COPY index.html /usr/local/apache2/htdocs/auth/index.html
COPY style.css /usr/local/apache2/htdocs/auth/css/style.css
COPY STAT-UP-Transparent-300.png /usr/local/apache2/htdocs/auth/css/STAT-UP-Transparent-300.png

# RUN sed -ri \
#    -e "s/^#(LoadModule.*mod_proxy.so)/\1/" \
#    -e "s/^#(LoadModule.*mod_proxy_http.so)/\1/" \
#    -e "s/^#(LoadModule.*mod_proxy_wstunnel.so)/\1/" \
#    -e "s/^#(LoadModule.*mod_headers.so)/\1/" \
#    -e "s/^#(LoadModule.*mod_rewrite.so)/\1/" \
#    -e "s/^#(LoadModule.*mod_session.so)/\1/" \
#    -e "s/^#(LoadModule.*mod_session_cookie.so)/\1/" \
#    -e "s/^#(LoadModule.*mod_auth_form.so)/\1/" \
#    -e "s/^#(LoadModule.*mod_request.so)/\1/" \
#    /usr/local/apache2/conf/httpd.conf

# COPY httpd.conf.addendum /usr/local/apache2/conf/httpd.conf.addendum
# RUN cat /usr/local/apache2/conf/httpd.conf.addendum >> /usr/local/apache2/conf/httpd.conf

COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY apache.sh /usr/local/apache2/bin
RUN chown root:root /usr/local/apache2/bin/apache.sh \
    && chmod 0500 /usr/local/apache2/bin/apache.sh

CMD /usr/local/apache2/bin/apache.sh

RUN mkdir /auth 
