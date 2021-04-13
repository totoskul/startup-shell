#!/bin/bash

dpkg-reconfigure tzdata;

apt update && apt upgrade -y;

apt autoremove;

apt install -y unattended-upgrades;

dpkg-reconfigure unattended-upgrades;

apt install -y ufw;

ufw allow ssh;
ufw allow http;
ufw allow https
ufw enable;

apt install fail2ban && service fail2ban start;

add-apt-repository ppa:ondrej/nginx -y && apt update;

apt install nginx -y;

echo "fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;" >> /etc/nginx/fastcgi_param;

service nginx restart;

rm /etc/nginx/sites-available/default && sudo rm /etc/nginx/sites-enabled/default;

echo "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    return 444;
}" >> /etc/nginx/nginx.conf;

service nginx restart;

add-apt-repository ppa:ondrej/php -y && apt update;

apt install php7.4-fpm php7.4-common php7.4-mysql \
php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd \
php7.4-imagick php7.4-cli php7.4-dev php7.4-imap \
php7.4-mbstring php7.4-opcache php7.4-redis \
php7.4-soap php7.4-zip -y;

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp;

apt-get install software-properties-common;

apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc';

add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirrors.up.pt/pub/mariadb/repo/10.4/ubuntu focal main';

apt install mariadb-server -y;

mysql_secure_installation;

apt install monit;




