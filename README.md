# [Helpful](http://helpful.io)
Support that makes you better at support.

[![Build Status](https://travis-ci.org/asm-helpful/helpful-web.png?branch=master)](https://travis-ci.org/asm-helpful/helpful-web)
[![Code Climate](https://codeclimate.com/github/support-foo/web.png)](https://codeclimate.com/github/support-foo/web)

Helpful is an open product that's being build by a fantastic group of people on [Assembly](https://assemblymade.com/support-foo). Anybody can join in building this product and earn a stake of the profit.

## Getting started

You need these installed locally to run Helpful:

* [Ruby 2.0.0](https://www.ruby-lang.org)
* [Postgres](http://www.postgresql.org)
* [Redis](http://redis.io)
* [ElasticSearch](http://www.elasticsearch.org/)
* [Heroku Toolbelt](https://toolbelt.heroku.com)

The following instructions are designed for Mac OS and assume you already have
[Homebrew](http://brew.sh/) installed.

### Install Helpful's dependencies (skip as needed)

#### Update Homebrew's Formulas
    brew update

#### Install rbenv (alternatively use RVM)
    brew install rbenv
    brew install ruby-build

#### Install Ruby 2.0.0
    rbenv install 2.0.0-p0

#### Install ElasticSearch
    brew install elasticsearch
    cp -s /usr/local/Cellar/elasticsearch/X.XX.X /usr/local/Cellar/elasticsearch/latest

#### Install Redis
    brew install redis
    cp -s /usr/local/Cellar/redis/X.XX.X /usr/local/Cellar/elasticsearch/redis

#### Install Postgres.app
1. Visit http://postgresapp.com/
2. Follow the instructions to install

### Setup Helpful

#### Get the code
    git clone https://github.com/asm-helpful/helpful-web.git
    cd helpful-web

#### Install the requied gems
    bundle install

#### Setup the databse
    cp config/database.yml.example config/database.yml

If you are using Postgres.app you don't need to edit anything, otherwise adjust database.yml as needed.

Once you're ready run:

    rake db:setup

#### Configure enviroment variables
Helpful uses enviroment variables to manage configuration.

To get started lets use the example .env which contains some good defaults:

    cp .env.example .env

It's probably a good idea to take a look at the contents of .env now.

### Starting Helpful

#### If you are running redis and elasticsearch already:

    rake search:reindex
    foreman start

#### If you are not running redis and elasticsearch and want them to run under foreman:
    cp Procfile.dev.example Procfile.dev
    # edit Procfile.dev as needed

    foreman start -f Procfile.dev
    rake search:reindex

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

Setting up Mailgun in development takes a little work but allows you to use the
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
3. Create a new WIP at https://assemblymade.com/support-foo/wips. Think of WIPs as GitHub issues.

Then just go ahead, fork the repo & issue a pull request. You're on your way to having a stake in Helpful.
