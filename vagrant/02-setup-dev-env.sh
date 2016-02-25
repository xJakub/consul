#!/bin/bash

# Disable firewall
sudo systemctl disable firewalld
sudo systemctl stop firewalld

bundle install
sed -e 's/@pgusername@/consul/' -e 's/@pgpassword@/consul/' config/database.yml.example > config/database.yml
cp config/secrets.yml.example config/secrets.yml
bin/rake db:setup
bin/rake db:dev_seed
RAILS_ENV=test bin/rake db:setup
