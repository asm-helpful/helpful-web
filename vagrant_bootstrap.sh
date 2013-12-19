#!/usr/bin/env bash

log () {
  echo -e "\n\e[35m-----> $1\n"
}

log "Updating Aptitude and installing the basics"
apt-get update
apt-get install curl python-software-properties -y

log "Installing Redis"
/usr/bin/add-apt-repository ppa:chris-lea/redis-server
apt-get update
apt-get install redis-server -y

log "Starting Redis"
service redis-server start

log "Installing ElasticSearch"
if dpkg -s elasticsearch > /dev/null 2>&1; then
  log "ElasticSearch is already installed. Trying to start it."
  service elasticsearch start
else
  apt-get install openjdk-6-jre-headless -y
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb
  dpkg -i elasticsearch-0.90.7.deb
  log "Starting ElasticSearch"
  service elasticsearch start
fi


log "Setting up Helpful"

# Get in the right directory
cd /vagrant

# Bundle
su vagrant -lc "cd /vagrant && bundle install"

# Setup .env
cp .env.example .env

log "Setting up the Database"
cp config/database.yml.example config/database.yml &&
su vagrant -lc "cd /vagrant && bundle exec rake db:setup"

# Trigger a reindex for ElasticSearch
su vagrant -lc "cd /vagrant && bundle exec rake search:reindex"

log "Starting Helpful"
su vagrant -lc "cd /vagrant && sudo foreman export upstart /etc/init \
  --app helpful \
  --user vagrant \
  --log /vagrant/log"

start helpful

cat <<EOF
-------------------------------------------------------------------------------
                                Helpful
                          An Assembly Product

Thanks for installing Helpful.

Open up http://localhost:5000 in your browser to get started.


Problems? Please contact us at helpful@helpful.io.
-------------------------------------------------------------------------------
EOF
