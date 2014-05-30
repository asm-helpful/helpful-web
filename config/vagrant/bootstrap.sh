#!/usr/bin/env bash

log () {
  echo -e "\n\e[35m-----> $1\n"
}

log "Updating Aptitude and Installing the Basics"
apt-get update
apt-get install curl python-software-properties -y


log "Installing and Starting Redis"
/usr/bin/add-apt-repository ppa:chris-lea/redis-server
apt-get update
apt-get install redis-server -y

if dpkg -s elasticsearch > /dev/null 2>&1; then
  log "Detected ElasticSearch"
  log "Starting ElasticSearch"
  service elasticsearch start
else
  log "Installing and Starting ElasticSearch"
  apt-get install openjdk-6-jre-headless -y
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb
  dpkg -i elasticsearch-0.90.7.deb
fi

(source /vagrant/config/vagrant/install-phantomjs.sh)

log "Setting up Helpful"

# Get in the right directory
cd /vagrant

# TODO: Make sure this happen in the vbox
sudo chmod -R g+ws /opt/ruby
sudo chown -R root:admin /opt/ruby

# Bundle
su vagrant -lc "cd /vagrant && bundle install"

# Setup .env
cp .env.example .env -n

log "Setting up the Database"
cp config/database.yml.example config/database.yml &&
su vagrant -lc "cd /vagrant && bundle exec rake db:setup"

# Trigger a reindex for ElasticSearch
su vagrant -lc "cd /vagrant && bundle exec rake search:reindex"

log "Starting Helpful"
su vagrant -lc "cd /vagrant && sudo foreman export upstart /etc/init \
  --app helpful \
  --user vagrant \
  --log /vagrant/log \
  --template /vagrant/config/vagrant/foreman/export_templates/upstart"

if ! restart helpful 2> /dev/null ; then
   start helpful;
fi

cat <<EOF
-------------------------------------------------------------------------------
                                Helpful
                          An Assembly Product

Thanks for installing Helpful.

Open up http://localhost:5000 in your browser to get started.

-------------------------------------------------------------------------------
EOF
