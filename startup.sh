#!/bin/bash

dpkg-reconfigure tzdata;

apt update && apt upgrade;

apt autoremove;

apt install unattended-upgrades;

dpkg-reconfigure unattended-upgrades;

apt install ufw;

ufw allow ssh;
ufw allow http;
ufw allow https
ufw enable;

apt install fail2ban && service fail2ban start;

add-apt-repository ppa:ondrej/nginx -y && apt update;

apt install nginx -y;

