#!/bin/bash


my_name="rohit"
s3_bucket="upgrad-rohit"
timestamp=$(date '+%d%m%Y-%H%M%S') 
apt -y update
apt -y  install awscli

server="apache2"
if dpkg -s  $server
then
	echo "$server installed"
else
        echo "$server NOT installed"
        apt -y  install apache2
fi
	
systemctl start apache2
systemctl enable apache2

echo "apache2 status:"
systemctl status apache2


cd /var/log/apache2/

tar -cvf $my_name-httpd-logs-$timestamp.tar *.log

cp $my_name-httpd-logs-$timestamp.tar /tmp/

aws s3 \
	cp /tmp/${my_name}-httpd-logs-${timestamp}.tar \
	s3://${s3_bucket}/${my_name}-httpd-logs-${timestamp}.tar


																	

