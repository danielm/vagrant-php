#!/bin/bash

# Some vars
apache_config_file="/etc/apache2/envvars"
apache_vhost_file="/etc/apache2/sites-available/vagrant_vhost.conf"

# This is the public folder of your project, where something like index.php is.
# Must be relative our the project path, so this asumes you have a public folder
# next to the Vagrantfile you just created
project_web_root="public"

apt-get update

# Network settings, because apache is a bitch
IPADDR=$(/sbin/ifconfig eth0 | awk '/inet / { print $2 }' | sed 's/addr://')
sed -i "s/^${IPADDR}.*//" /etc/hosts

echo ${IPADDR} ubuntu.localhost >> /etc/hosts

# Some utilities i like to have
apt-get -y install git curl unzip

# Installing Apache
apt-get -y install apache2

# Some user tweaks needed; we basically tell apache to use vagrant's user instead www-data
sed -i "s/^\(.*\)www-data/\1ubuntu/g" ${apache_config_file}
chown -R ubuntu:ubuntu /var/log/apache2

# Creare our new virtual host
if [ ! -f "${apache_vhost_file}" ]; then
    cat << EOF > ${apache_vhost_file}

    ServerAdmin webmaster@localhost
    DocumentRoot /vagrant/${project_web_root}
    LogLevel debug 
    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined# 
    
    <Directory /vagrant/${project_web_root}>
        AllowOverride All
        Require all granted
    </Directory>
EOF
fi

# Disable default "hello world" site, and enable ours
a2dissite 000-default
a2ensite vagrant_vhost

# Reload apache and install it as a service
service apache2 reload
update-rc.d apache2 enable

# PHP 7; also Curl and Cli are required by composer
apt-get -y install php php-curl php-cli libapache2-mod-php7.0

# Reload apache
service apache2 reload

# Install latest version of Composer globally
if [ ! -f "/usr/local/bin/composer" ]; then
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
fi