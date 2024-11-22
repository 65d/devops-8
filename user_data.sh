#!/bin/bash

sudo dnf update -y
sudo dnf install -y httpd mod_ssl openssl

sudo systemctl start httpd
sudo systemctl enable httpd

sudo mkdir -p /etc/httpd/ssl

sudo mkdir -p /var/www/html/http
sudo mkdir -p /var/www/html/https

sudo openssl req -x509 -newkey rsa:4096 -keyout /etc/httpd/ssl/my.key \
    -out /etc/httpd/ssl/my.crt -sha256 -days 3650 -nodes \
    -subj "/C=UA/ST=Kyiv/L=Kyiv/O=ITSTEP/OU=ITDepartment/CN=lab8/emailAddress=test@test.com"


echo "<html><body><h1>Welcome to your EC2 Apache Server on http</h1></body></html>" >> /var/www/html/http/index.html
echo "<html><body><h1>Welcome to your EC2 Apache Server on https</h1></body></html>" >> /var/www/html/https/index.html


sudo bash -c 'cat <<EOT > /etc/httpd/conf.d/vhost.conf
<VirtualHost *:80>
    DocumentRoot "/var/www/html/http"
</VirtualHost>

<VirtualHost *:443>
    DocumentRoot "/var/www/html/https"
    SSLEngine on
    SSLCertificateFile /etc/httpd/ssl/my.crt
    SSLCertificateKeyFile /etc/httpd/ssl/my.key
</VirtualHost>
EOT'

sudo sed -i '/<VirtualHost _default_:443>/,/<\/VirtualHost>/d' /etc/httpd/conf.d/ssl.conf

sudo systemctl restart httpd


sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --reload
