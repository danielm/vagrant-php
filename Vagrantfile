
#
# File: Vagrantfile
# 
# By: Daniel Morales <daniminas@gmail.com>
#
# Web: https://github.com/danielm/vagrant-php
#
# Licence: GPL/MIT

# Configuration file version
Vagrant.configure(2) do |config|

  # Box
  config.vm.box = "ubuntu/focal64"

  # This forwards apache's 80 to 8080 on your development pc 
  # and allows you to access http://localhost:8080 in your browser
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Avoid to problems when using command (example artisain, nut, etc). 
  # Also avoids dealing with permissions problems of cache folders / sessions / etc some frameworks use
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root",
  	owner: "vagrant",
  	group: "www-data",
  	mount_options: ["dmode=775,fmode=664"]

  # Provisioning our Box
  config.vm.provision "shell", inline:<<-SHELL
    # Vars
    apache_vhost_file="/etc/apache2/sites-available/vagrant_vhost.conf"
    mysql_root_pass="1234567"

    # Upgrade distro first
    apt-get update
    apt-get upgrade -y

    # Some utilities i like to have
    apt-get -y install git curl unzip

    apt-get -y install apache2

    # Creare our new virtual host
  if [ ! -f "${apache_vhost_file}" ]; then
    cat << EOF > ${apache_vhost_file}
<VirtualHost *:8080>

ServerAdmin webmaster@localhost
VirtualDocumentRoot /vagrant/%1/public
ServerAlias *.devel

LogLevel debug
ErrorLog /var/log/apache2/error.log
CustomLog /var/log/apache2/access.log combined
<Directory /vagrant>
    AllowOverride All
    Require all granted
</Directory>

</VirtualHost>

EOF
  fi

  # TODO: REEMPLAZAR  Listen 80 POR 8080 en ports.conf

  # Disable "default" site, and enable ours
  a2dissite 000-default
  a2ensite vagrant_vhost
 
  # enable some modules
  a2enmod rewrite
  a2enmod vhost_alias

  # PHP 7; also Curl and Cli are required by composer
  apt-get -y install php php-curl php-dom php-cli libapache2-mod-php

  # Some other packages
  apt-get -y install php-mbstring php-intl php-sqlite3 php-gd

  # Install latest version of Composer globally
  if [ ! -f "/usr/local/bin/composer" ]; then
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  fi

  # export PATH="$PATH:$HOME/.config/composer/vendor/bin"
  # composer global require laravel/installer

  # MySql
  debconf-set-selections <<< "mysql-server mysql-server/root_password password ${mysql_root_pass}"
  debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${mysql_root_pass}"
  apt-get -y install mysql-server php-mysql

  # Redis
  apt-get install redis php-redis

  # Finish up stuff
  service apache2 restart
  apt-get -y autoremove

  # Laravel installer
  #export PATH="$PATH:$HOME/.config/composer/vendor/bin"
  #composer global require laravel/installer

  #export PATH=$PATH:$HOME/.config/composer/vendor/bin:$HOME/.symfony/bin

SHELL

  # Provisioning our Box
  # config.vm.provision "shell", run: "always", inline:<<-SHELL
  # service apache2 status > /dev/null 2>&1
  # if [ $? -ne 0 ]; then
  #     service apache2 start
  # fi
#SHELL

end
