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
  config.vm.box = "ubuntu/xenial64"

  # This forwards apache's 80 to 8080 on your development pc 
  # and allows you to access http://localhost:8080 in your browser
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Avoid to problems when using command (example artisain, nut, etc). 
  # Also avoids dealing with permissions problems of cache folders / sessions / etc some frameworks use
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root",
  	owner: "ubuntu",
  	group: "www-data",
  	mount_options: ["dmode=775,fmode=664"]

  # Provisioning our Box
  config.vm.provision "shell", path: "scripts/provision.sh"

  # Some routines we may need every time we vagrant up
  config.vm.provision "shell", path: "scripts/always.sh", run: "always"
end
