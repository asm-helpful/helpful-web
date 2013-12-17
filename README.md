# [Helpful](http://helpful.io)
Support that makes you better at support.

[![Build Status](https://travis-ci.org/asm-helpful/helpful-web.png?branch=master)](https://travis-ci.org/asm-helpful/helpful-web)
[![Code Climate](https://codeclimate.com/github/support-foo/web.png)](https://codeclimate.com/github/support-foo/web)

Helpful is an open product that's being build by a fantastic group of people on [Assembly](https://assemblymade.com/helpful). Anybody can join in building this product and earn a stake of the profit.

## Getting Started
NOTE: These directions are targeted at Mac Users.

### Vagrant
[Vagrant](http://vagrantup.com) is a great way to quickly get started on Helpful.

Pre-requisites:

* [Vagrant](http://www.vagrantup.com/) - Download from http://vagrantup.com/downloads

Once you have Vagrant installed run:

    vagrant up

This will take a while to run so you may want to grab some coffee.

Once Vagrant finishes follow the onscreen instructions to finish the install process. That's it.

**Welcome to Helpful.**

<<<<<<< HEAD
### Bootstrap.sh
If you prefer a local (non VM) install you can use the included `bootstrap.sh` script to help you get everything setup.

Pre-requisites:

* [Ruby 2.0](https://www.ruby-lang.org) - Install via [rbenv](http://rbenv.org/) or [RVM](https://rvm.io/‎)
* [PostgreSQL](http://www.postgresql.org) - Install via [Postgres.app](http://postgresapp.com)

Once you have the pre-requisites installed:

    ./boostrap.sh

Once `bootstrap.sh` finishes follow the onscreen instructions to finish the install process. That's it.

**Welcome to Helpful.**

### Manual

If you prefer to install everything manually (or you're not on a Mac) here is what you will need:

* [Git](http://git-scm.com)
* [Ruby 2.0](https://www.ruby-lang.org)
* [Bundler](http://bundler.io/)
* [PostgreSQL](http://www.postgresql.org)
* [ElasticSearch](http://elasticsearch.org)
* [Redis](http://redis.io)

Once you have everything installed:

    # Get the Source Code
    git clone https://github.com/asm-helpful/helpful-web.git
    cd helpful-web

    # Install Gems
    bundle install

    # Create a database config (edit as needed)
    cp config/database.yml.example config/database.yml
    rake db:setup

    # Create an environment config (edit as needed)
    cp .env.example .env

    # Re-index ElasticSearch
    rake search:reindex

    # Start the server (assumes you have redis and elasticsearch already running)
    foreman start

Open up http://localhost:5000 in your web browser.

**Welcome to Helpful.**

### Using Helpful

1. Open up http://localhost:5000 in your web browser. You should see the Helpful.io landing page.
2. To get started click "Sign Up" and follow the instructions.
3. Enjoy!

## Advanced Configuration

### Email

#### Sending with Gmail

In development.rb, add:

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        address:              'smtp.gmail.com',
        port:                 587,
        domain:               'example.com',
        user_name:            'your_gmail_username',
        password:             'your_gmail_password',
        authentication:       'plain',
        enable_starttls_auto: true
    }

#### Recieving with Mailgun (optional)

Setting up [Mailgun](http://mailgun.com) in development takes a little work but allows you to use the
actual email workflow used in production.

1. Register for a free account at https://mailgun.com.
2. Get your Mailgun API key from https://mailgun.com/cp it starts with "key-"
and add it to your .env file as MAILGUN_API_KEY.
4. Get your Mailgun test subdomain from the same page and add it to your .env
file as INCOMING_EMAIL_DOMAIN.
5. In order to recieve webhooks from Mailgun we need to expose our development
instance to the outside world. We can use a tool called
[Ngrok](http://ngrok.com) for this. Download and setup Ngrok by following the
instructions on the [Ngrok](http://ngrok.com) site.
6. Run rake mailgun to make sure everything is setup right. It should prompt you
to create a route using `rake mailgun:create_route`.
7. Run `rake mailgun:create_route` and when prompted enter your Ngrok address
as the domain name.
8. Send a test email to helpful@INCOMING_EMAIL_DOMAIN and you should see it
appear in the helpful account.

## Contributing

There are a couple of steps you need to take before contributing:

1. Go to https://assemblymade.com and sign up.
2. Link your GitHub account to your Assembly account
3. Create a new WIP at https://assemblymade.com/helpful/wips. Think of WIPs as GitHub issues.

Then just go ahead, fork the repo & issue a pull request. You're on your way to having a stake in Helpful.
