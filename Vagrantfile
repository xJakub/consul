# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.

  config.vm.box = "imartinezortiz/centos72"
  config.vm.box_version = ">= 0.1.0"
  config.vm.provision "shell", path: "vagrant/00-install-consul-deps.sh"
  config.vm.network "forwarded_port", guest: 3000, host: 8000
end
