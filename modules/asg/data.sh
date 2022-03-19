#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd && sudo systemctl enable 
echo "Hello world from $(hostname -f)" > /var/www/html/index.html
