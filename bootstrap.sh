#!/usr/bin/env bash

apt-get update
apt-get install build-essential

wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
sudo make install
cd utils
yes '' | sudo ./install_server.sh

sudo apt-get install curl python-software-properties -y
sudo apt-get install openjdk-6-jre-headless -y
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.7.deb
sudo dpkg -i elasticsearch-0.90.7.deb
sudo service elasticsearch start