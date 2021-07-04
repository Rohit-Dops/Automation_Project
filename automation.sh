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


#adding invertory page for apache2
																	

path="/var/www/html"

if [[ ! -f $path/inventory.html ]]; 
then
	echo -e 'Log Type\t-\tTime Created\t-\tType\t-\tSize' >> $path/inventory.html
fi

if [[ -f $path/inventory.html ]]; 
then
			        
	size=$(du -h /tmp/$my_name-httpd-logs-$timestamp.tar | awk '{print $1}')
	echo -e "httpd-logs\t-\t$timestamp\t-\ttar\t-\t$size" >> $path/inventory.html
fi


# adding cronjob for script

if [ -f "/etc/cron.d/automation" ];
then
	echo "Automation script already exist"
else
	touch /etc/cron.d/automation
	printf "0 0 * * * root /root/Automation_Project/auotmation.sh" > /etc/cron.d/automation
fi
