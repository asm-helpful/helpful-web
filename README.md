# [Helpful](http://helpful.io)
Support that makes you better at support.

[![Build Status](https://travis-ci.org/support-foo/web.png?branch=master)](https://travis-ci.org/support-foo/web)
[![Code Climate](https://codeclimate.com/github/support-foo/web.png)](https://codeclimate.com/github/support-foo/web)

Helpful is an open product that's being build by a fantastic group of people on [Assembly](https://assemblymade.com/support-foo). Anybody can join in building this product and earn a stake of the profit.


## Getting started

You need [Ruby 2.0.0](https://www.ruby-lang.org), [Postgres](http://www.postgresql.org), [Redis](http://redis.io) and the [Heroku Toolbelt](https://toolbelt.heroku.com) installed locally to run Helpful. 
  
    # Install dependent gems
    $ bundle install --binstubs
    
    # Configure the environment
    $ cp .env.example .env
    # edit .env
    
    # Setup the database
    $ cp config/database.yml.example config/database.yml
    # edit config/database.
    $ bin/rake db:setup
    
    # Start the server
    $ foreman start
    # open localhost:5000 in your browser

    # Play with sandbox
    $ rake seed:message from=some_email@test.com
    # open localhost:5000/conversations in your browser

### Experimental IMAP Support

Helpful has an experimental script for fetching email from an IMAP. To use this functionality you will need to .env and enter the details for the following environment variables:

    MAILMAN_IMAP_SERVER
    MAILMAN_IMAP_PORT
    MAILMAN_IMAP_USERNAME
    MAILMAN_IMAP_PASSWORD
    MAILMAN_IMAP_FOLDER
    MAILMAN_IMAP_POLL (rate at which mailman should poll imap for new emails)

To run this script (using `foreman run` loads settings from .env)

    $ foreman run bin/mailman_worker


## Contributing

There are a couple of steps you need to take before contributing:

1. Go to https://assemblymade.com and sign up.
2. Link your GitHub account to your Assembly account
3. Create a new WIP at https://assemblymade.com/support-foo/wips. Think of WIPs as GitHub issues.

Then just go ahead, fork the repo & issue a pull request. You're on your way to having a stake in Helpful.
