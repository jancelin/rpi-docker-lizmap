
FROM resin/rpi-raspbian:latest
MAINTAINER Julien Ancelin / rpi-docker-lizmap
# Install 
RUN apt-get -y update \
    && apt-get -t jessie install -y  python-simplejson xauth htop vim curl ntp ntpdate ssl-cert\ 
    python-software-properties git wget unzip \
    apache2 apache2-mpm-worker apache2-mpm-prefork apache2-bin apache2-data \
    libapache2-mod-fcgid libapache2-mod-php5 php5 php5-common php5-cgi php5-curl\
    php5-cli php5-sqlite php5-gd php5-pgsql \
    && apt-get clean && apt-get -y autoremove
#config 
RUN a2dismod php5; a2enmod actions; a2enmod fcgid ; a2enmod ssl; a2enmod rewrite; a2enmod headers; \
    a2enmod deflate; a2enmod php5

ADD files /home/files
RUN mv /home/files/mod_deflate.conf /etc/apache2/conf.d/mod_deflate.conf && \
    mv /home/files/php.conf /etc/apache2/conf.d/php.conf && \
    mv /home/files/fcgid.conf /etc/apache2/mods-enabled/fcgid.conf && \
    mv /home/files/apache_https.conf /etc/apache2/sites-available/default-ssl.conf && \
    mv /home/files/apache.conf /etc/apache2/sites-available/000-default.conf && \
    mv /home/files/apache2.conf /etc/apache2/apache2.conf && \
    mv /home/files/fcgid.conf /etc/apache2/mods-available/fcgid.conf && \
    mv /home/files/pg_service.conf /etc/pg_service.conf && \
    mv /home/files/setup.sh /setup.sh && \
    mv /home/files/index.html /var/www/index.html && \
    mv /home/files/start.sh /start.sh
# Configure apache
RUN mkdir /etc/apache2/ssl
RUN /usr/sbin/make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/ssl/apache.pem
RUN /usr/sbin/a2ensite default-ssl

# pg service file
ENV PGSERVICEFILE /etc/pg_service.conf
#-----------------install lizmap-web-client-------------------------------
# Download & unzip & install
ADD https://github.com/3liz/lizmap-web-client/archive/3.1.1.zip /var/www/

RUN chmod +x /setup.sh \
    && /setup.sh
VOLUME  /var/www/websig/lizmap/var
VOLUME /home

RUN chmod 0755 /start.sh
# Open port 80 443 
EXPOSE 80
EXPOSE 443
# Now launch apache in the foreground
CMD /start.sh

