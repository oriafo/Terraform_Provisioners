#!/bin/bash -xe
sudo apt update
sudo apt install wget unzip -y
sudo apt install nginx -y
# sudo ufw allow 'Nginx HTTP'
# sudo ufw status
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
sudo wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
#sudo wget https://www.tooplate.com/zip-templates/2137_barista_cafe.zip
sudo unzip 2137_barista_cafe.zip -d /var/www/html
sudo cp -r /var/www/html/2137_barista_cafe/* /var/www/html
sudo nginx -s reload
sudo systemctl restart nginx

