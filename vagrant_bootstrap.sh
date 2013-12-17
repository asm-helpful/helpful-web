#!/usr/bin/env bash

# Update apt-get and install the basics
apt-get update
apt-get install curl python-software-properties -y

# Install Redis
/usr/bin/add-apt-repository ppa:chris-lea/redis-server
apt-get update
apt-get install redis-server -y
service redis-server start

# Install ElasticSearch
if dpkg -s elasticsearch > /dev/null 2>&1; then
  echo "Looks like elasticsearch is already installed. Trying to start it."
  service elasticsearch start
else
  apt-get install openjdk-6-jre-headless -y
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb
  dpkg -i elasticsearch-0.90.7.deb
  service elasticsearch start
fi

# Setup Helpful
cd /vagrant
su vagrant -lc "cd /vagrant && bundle install"

cp config/database.yml.example config/database.yml &&
su vagrant -lc "cd /vagrant && rake db:setup"

cp .env.example .env
su vagrant -lc "cd /vagrant && rake search:reindex"
cat <<EOF
-------------------------------------------------------------------------------
                                Helpful
                          An Assembly Product

Let's get started, just run the following commands to get up and running:

$ vagrant ssh
$ cd /vagrant
$ foreman start

If everything looks ok, open up http://localhost:5000 in your browser.

Welcome to Helpful.
-------------------------------------------------------------------------------
EOF
