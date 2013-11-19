#!/usr/bin/env bash

log () {
  echo "-----> $1"
}

log "Installing Postgresql"
sudo apt-get install postgresql-contrib

log "Installing Redis"
sudo apt-get install redis-server

log "Starting Redis"
sudo service redis-server start

log "Installing ElasticSearch"
sudo apt-get install curl python-software-properties -y
sudo apt-get install openjdk-6-jre-headless -y
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb
sudo dpkg -i elasticsearch-0.90.7.deb

log "Starting ElasticSearch"
sudo service elasticsearch start


cd /vagrant

log "Installing gems"
bundle install

log "Configuring database"
cp config/database.yml.example config/database.yml
createuser --createdb --no-password root --user vagrant
bin/rake db:setup

log "Configuring environment"
cp .env.example .env

log "Starting Helpful"
sudo foreman export upstart /etc/init \
  --app helpful \
  --user vagrant \
  --log /var/helpful/log
