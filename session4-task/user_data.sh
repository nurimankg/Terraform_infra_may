#!/bin/bash
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl restart httpd
sudo echo "Welcome to  ${env} webserver" > /var/www/html/index.html
sudo chown -R  apache:apache /var/www/html/