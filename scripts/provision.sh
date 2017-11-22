#!/bin/bash
#
# File: scripts/provision.sh
# 
# By: Daniel Morales <daniminas@gmail.com>
#
# Web: https://github.com/danielm/vagrant-php
#
# Licence: GPL/MIT

# Some vars
apache_config_file="/etc/apache2/envvars"
apache_vhost_file="/etc/apache2/sites-available/vagrant_vhost.conf"

# This is the public folder of your project, where something like index.php is.
project_web_root="/vagrant/app/public"

mysql_root_pass="1234567"

main() {
  do_setup
  do_tools
  do_apache
  do_php
  do_mysql
  do_phpmyadmin
  do_finish
}

do_setup() {
  apt-get update
}

do_tools() {
  # Some utilities i like to have
  apt-get -y install git curl unzip
}

do_apache() {
  # Installing Apache
  apt-get -y install apache2

  # Creare our new virtual host
  if [ ! -f "${apache_vhost_file}" ]; then
    cat << EOF > ${apache_vhost_file}
ServerAdmin webmaster@localhost
DocumentRoot ${project_web_root}
LogLevel debug 
ErrorLog /var/log/apache2/error.log
CustomLog /var/log/apache2/access.log combined 

<Directory ${project_web_root}>
    AllowOverride All
    Require all granted
</Directory>
EOF
  fi

  # Disable default "hello world" site, and enable ours
  a2dissite 000-default
  a2ensite vagrant_vhost
}

do_php() {
  # PHP 7; also Curl and Cli are required by composer
  apt-get -y install php php-curl php-cli libapache2-mod-php

  # Some other packages
  apt-get -y install php-mcrypt php-mbstring php-intl

  # Install latest version of Composer globally
  if [ ! -f "/usr/local/bin/composer" ]; then
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  fi
}

do_mysql() {
  debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_root_pass}"
  debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${mysql_root_pass}"

  apt-get -y install mysql-server php-mysql
}

do_phpmyadmin() {
  debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
  debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password ${mysql_root_pass}"
  debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password ${mysql_root_pass}"
  debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password ${mysql_root_pass}"
  debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

  apt install -y phpmyadmin
}

do_finish() {
  # restart apache
  service apache2 restart

  # Remove unnecessary stuff
  apt-get -y autoremove
}

#
# Run EVERYTHING!
#
main
exit 0
