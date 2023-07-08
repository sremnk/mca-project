#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on
echo "<h1>HELLO from $(hostname)</h1>" > /var/www/html/index.html