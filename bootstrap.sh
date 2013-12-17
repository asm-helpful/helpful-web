#!/usr/bin/env bash

if which rbenv > /dev/null 2>&1; then
  echo "rbenv detected. Using rbenv rehash."
  rbenv rehash
  RBENV=true
fi


if ! which brew > /dev/null 2>&1; then
  echo "Could not find Homebrew (http://brew.sh). Please install and try again."
  exit 1
fi

echo "\n
====Installing Dependencies via Homebrew=======================================
"
brew update

brew install redis

brew install elasticsearch

brew install heroku

echo -n "If there are any caveats above you should review them now.
Please any key when ready to continue........."
read response


echo "\n
====Installing Gems=============================================================
"

# Setup Helpful

echo "Attempting RubyGems Update. You may already have the latest version."
gem update --system
if $RBENV; then rbenv rehash; fi

if test -e "/Applications/Postgres93.app/Contents/MacOS/bin/pg_config"; then
  echo "Postgres93.app detected. Setting with-pg-config for Bundler."
  export CONFIGURE_ARGS="with-pg-config=/Applications/Postgres93.app/Contents/MacOS/bin/pg_config"
fi

if test -e "/Applications/Postgres.app/Contents/MacOS/bin/pg_config"; then
  echo "Postgres.app detected. Setting with-pg-config for Bundler."
  export CONFIGURE_ARGS="with-pg-config=/Applications/Postgres.app/Contents/MacOS/bin/pg_config"
fi

gem install bundler
gem install foreman
bundle install
if $RBENV; then rbenv rehash; fi

echo "\n
====Setting up Helpful=========================================================
"
cp config/database.yml.example config/database.yml
bundle exec rake db:setup

cp .env.example .env
bundle exec rake search:reindex

cat <<EOF
-------------------------------------------------------------------------------
                                Helpful
                          An Assembly Product

Ok that's it, just run the following commands to get up and running:

$ foreman start

If everything looks ok, open up http://localhost:5000 in your browser.

Welcome to Helpful.
-------------------------------------------------------------------------------
EOF
