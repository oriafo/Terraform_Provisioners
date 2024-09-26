#!/bin/bash -xe
sudo apt update
apt install wget unzip -y
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
sudo ufw status
systemctl enable nginx
systemctl status nginx
wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
unzip 2137_barista_cafe.zip -d /var/www/html
cp -r /var/www/html/2137_barista_cafe/* /var/www/html
nginx -s reload
systemctl restart nginx