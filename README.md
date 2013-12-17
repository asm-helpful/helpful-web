# [Helpful](http://helpful.io)
Support that makes you better at support.

[![Build Status](https://travis-ci.org/asm-helpful/helpful-web.png?branch=master)](https://travis-ci.org/asm-helpful/helpful-web)
[![Code Climate](https://codeclimate.com/github/support-foo/web.png)](https://codeclimate.com/github/support-foo/web)

Helpful is an open product that's being build by a fantastic group of people on [Assembly](https://assemblymade.com/support-foo). Anybody can join in building this product and earn a stake of the profit.

## Getting Started with Vagrant
[Vagrant](http://vagrantup.com) is a great way to quickly get started on Helpful.

If you don't already have Vagrant installed download it here: http://www.vagrantup.com/downloads before continuing.

Once you have Vagrant installed you can run:

		vagrant up
		
This will take a while to run so you may want to grab some coffee. Once Vagrant finishes follow the onscreen instructions to finish the install process. That's it.

Welcome to Helpful.

## Getting started
You need these installed locally to run Helpful:

* [Ruby 2.0.0](https://www.ruby-lang.org)
* [Postgres](http://www.postgresql.org)
* [Redis](http://redis.io)
* [ElasticSearch]()
* [Heroku Toolbelt](https://toolbelt.heroku.com)

    # Install dependent gems
    bundle install

    # Setup the database
    cp config/database.yml.example config/database.yml
    # edit config/database.
    rake db:setup

    # Install & Setup dependencies (for Mac)
    brew install elasticsearch
    cp -s /usr/local/Cellar/elasticsearch/X.XX.X /usr/local/Cellar/elasticsearch/latest
    brew install redis
    cp -s /usr/local/Cellar/redis/X.XX.X /usr/local/Cellar/elasticsearch/redis

    # Configure the environment
    cp .env.example .env
    # Edit the .env file to customize the options in there (the defaults are pretty sane if you followed this guide, but you should check)

### If you are running redis and elasticsearch already:

    $ foreman start

### If you are not running redis and elasticsearch seperately and would like to run them in the same session:

    $ cp Procfile.dev.example Procfile.dev
    # edit Procfile.dev

    # Start the server
    $ foreman start -f Procfile.dev
    # open localhost:5000 in your browser

### Send a test message to the app

Once you've created an account you can send it test messages using the API:

    curl -X POST http://helpful.io/api/messages \
             --data "account=helpful" \
             --data "email=user@example.com" \
             --data "content=I need help please."

### Configuring Search (Elastic Search)

On OS X:

    brew install elasticsearch
    elasticsearch -f
    rake search:reindex
    foreman start

### Configuring Analytics (Segment.io)

You can get some analytics from your app by configuring a [Segment.io](https://segment.io/) secret key in .env:

    SEGMENT_SECRET=XXXXXXXXXXXX

### Configuring Email

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

## OAuth2

API authentication is done using OAuth2.  Helpful acts as an OAuth2 provider.  In order to develop an API client against
Helpful, your app will need to be registered.

More details here:

* https://github.com/applicake/doorkeeper/wiki/Authorization-Code-Flow
* http://tools.ietf.org/html/rfc6749#section-4.1

Roughly, as a Helpful user, you can:

* Create your own 'applications' (OAuth clients) that can then participate in the OAuth flow.  Use the "/oauth/applications" URL.
* Authorize other applications (or your own) to "act" on your behalf (make API calls to resources you control).  Use the "/oauth/authorized_applications" URL.

Here's how to do it in development:

1. Log in as normal
2. Visit http://localhost:3000/oauth/applications
3. Create a new application (use `urn:ietf:wg:oauth:2.0:oob` as the callback URL)
4. Copy the application_id and secret key

When your app/client code wants to access Helpful as a user, it must request an auth_code.  That is done by having the user you want to act on behalf of visit the authorize_url:

```ruby
callback = "urn:ietf:wg:oauth:2.0:oob"
app_id = "f9682933bb81c9a76cc4dc6d7b2f4ba7a1db006cc986fa5e8e28d05fafde6dd9"
secret = "23c7ebff714494e3871cf0ab163bb4e9b87bd4ad201521a3ce9e2e1ca984feda"

client = OAuth2::Client.new(app_id, secret, site: "http://localhost:3000/")

client.auth_code.authorize_url(redirect_uri: callback)
 # => "http://localhost:3000/oauth/authorize?response_type=code&client_id=f9682933bb81c9a76cc4dc6d7b2f4ba7a1db006cc986fa5e8e28d05fafde6dd9&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob"
```

5. This URL will prompt the browser user if they want to allow the app and will return to you an auth_code (via callback or in the browser window).
6. Your app should remember this auth_code!
7. Then "trade-in" the auth_code for an access_token (Access tokens are short lived (2 hours).  Whenever it expires, you'll have to get a new one.

```
auth_code = "b789332903d1a6e3ec07f1831c8c4e3d20031f576e19ff2ae24dcbb26285b205"
access = client.auth_code.get_token auth_code, redirect_uri: callback
token = access.token
# => "fd7958b3d3d17ba9130718096b3a4cd4a4d8088cb29d41e4d74513fc9aeff5a8"

access.get '/api/messages'
# => #<OAuth2::Response:0x000000027c2778 .... (Normal HTTP Response stuff from the API call here)
```

## Contributing

There are a couple of steps you need to take before contributing:

1. Go to https://assemblymade.com and sign up.
2. Link your GitHub account to your Assembly account
3. Create a new WIP at https://assemblymade.com/support-foo/wips. Think of WIPs as GitHub issues.

Then just go ahead, fork the repo & issue a pull request. You're on your way to having a stake in Helpful.
