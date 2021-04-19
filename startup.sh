#!/bin/bash

dpkg-reconfigure tzdata;

apt update && apt upgrade -y;

apt autoremove;

sed -i "s/#Port 22/Port 6969/" /etc/ssh/sshd_config;

apt install -y unattended-upgrades;

dpkg-reconfigure unattended-upgrades;

# ufw
apt install -y ufw;
ufw alolow 22;
ufw allow 6969;
ufw allow http;
ufw allow https
ufw enable;

# fail2ban
apt install fail2ban && service fail2ban start;

# nginx
add-apt-repository ppa:ondrej/nginx -y && apt update;

apt install nginx -y;

#echo "fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;" >> /etc/nginx/fastcgi_param;

service nginx restart;

rm /etc/nginx/sites-available/default && sudo rm /etc/nginx/sites-enabled/default;

#echo "server {
#    listen 80 default_server;
#    listen [::]:80 default_server;
#    server_name _;
#    return 444;
#}" >> /etc/nginx/nginx.conf;

service nginx restart;
# php
add-apt-repository ppa:ondrej/php -y && apt update;

apt install php7.4-fpm php7.4-common php7.4-mysql \
php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd \
php7.4-imagick php7.4-cli php7.4-dev php7.4-imap \
php7.4-mbstring php7.4-opcache php7.4-redis \
php7.4-soap php7.4-zip -y;

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp;

# MariaDB
apt-get install software-properties-common;

apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc';

add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirrors.up.pt/pub/mariadb/repo/10.4/ubuntu focal main';

apt install mariadb-server -y;

mysql_secure_installation;

# Mmonit
apt install monit;
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/nginx;
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/mysql;
service monit restart;

# certbot
# 
wget https://dl.eff.org/certbot-auto && chmod a+x ./certbot-auto && ./certbot-auto --install-only;

service ssh restart;

# endlessh install
cd /usr/share;
git clone https://github.com/skeeto/endlessh;

cd endlessh;
make;
make install;
cp util/endlessh.service /etc/systemd/system;
systemctl enable endlessh;

mkdir -p /etc/endlessh;
cd ;
cp endlessh/config /etc/endlessh/config;
systemctl start endlessh;

