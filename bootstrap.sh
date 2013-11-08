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