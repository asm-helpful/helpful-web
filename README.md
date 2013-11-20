# [Helpful](http://helpful.io)
Support that makes you better at support.

[![Build Status](https://travis-ci.org/asm-helpful/helpful-web.png?branch=master)](https://travis-ci.org/asm-helpful/helpful-web)
[![Code Climate](https://codeclimate.com/github/support-foo/web.png)](https://codeclimate.com/github/support-foo/web)

Helpful is an open product that's being build by a fantastic group of people on [Assembly](https://assemblymade.com/support-foo). Anybody can join in building this product and earn a stake of the profit.


## Getting started

You need [Ruby 2.0.0](https://www.ruby-lang.org), [Postgres](http://www.postgresql.org), [Redis](http://redis.io) and the [Heroku Toolbelt](https://toolbelt.heroku.com) installed locally to run Helpful.

    # Install dependent gems
    $ bundle install

    # Setup the database
    $ cp config/database.yml.example config/database.yml
    # edit config/database.
    $ bin/rake db:setup

    # Install & Setup dependencies (for Mac)
    $ brew install elasticsearch
    $ cp -s /usr/local/Cellar/elasticsearch/X.XX.X /usr/local/Cellar/elasticsearch/latest
    $ brew install redis
    $ cp -s /usr/local/Cellar/redis/X.XX.X /usr/local/Cellar/elasticsearch/redis

    # Configure the environment
    $ cp .env.example .env
    # edit .env

### If you are running redis and elasticsearch already:

    $ foreman start

### If you are not running redis and elasticsearch seperately and would like to run them in the same session:

    $ cp Procfile.dev.example Procfile.dev
    # edit Procfile.dev

    # Start the server
    $ foreman start -f Procfile.dev
    # open localhost:5000 in your browser

### Send a test message to the app

    $ rake seed:message from=some_email@test.com
    # open localhost:5000 in your browser

### Experimental IMAP Support

Helpful has an experimental script for fetching email from an IMAP. To use this functionality you will need to .env and enter the details for the following environment variables:

    MAILMAN_IMAP_SERVER
    MAILMAN_IMAP_PORT
    MAILMAN_IMAP_USERNAME
    MAILMAN_IMAP_PASSWORD
    MAILMAN_IMAP_FOLDER

To run this script

    $ bin/mailman

### Configuring Search (Elastic Search)

On OS X:

    brew install elasticsearch
    elasticsearch -f
    rake search:reindex
    foreman start

### Configuring Analytics (Segment.io)

You can get some analytics from your app by configuring a [Segment.io](https://segment.io/) secret key in .env:

    SEGMENT_SECRET=XXXXXXXXXXXX

## Contributing

There are a couple of steps you need to take before contributing:

1. Go to https://assemblymade.com and sign up.
2. Link your GitHub account to your Assembly account
3. Create a new WIP at https://assemblymade.com/support-foo/wips. Think of WIPs as GitHub issues.

Then just go ahead, fork the repo & issue a pull request. You're on your way to having a stake in Helpful.
