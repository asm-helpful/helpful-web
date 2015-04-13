source 'https://rubygems.org'
ruby '2.1.2'

# Load environment variables first

gem 'dotenv-rails', groups: [:development, :test]

# Alphabetical list

gem 'active_model_serializers', github: 'rails-api/active_model_serializers', branch: '0-8-stable'
gem 'analytics-ruby', '~> 2.0.0', require: 'segment/analytics'
gem 'awesome_print'
gem 'aws-sdk'
gem 'bootstrap-sass', github: 'twbs/bootstrap-sass'
gem 'bourbon'
gem 'bugsnag'
gem 'carrierwave-aws'
gem 'confyio'
gem 'curb'
gem 'customerio'
gem 'devise_invitable', '~> 1.3'
gem 'devise-i18n'
gem 'devise', '~> 3.1'
gem 'doorkeeper'
gem 'elasticsearch-model'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 5.0'
gem 'httparty'
gem 'jquery-rails'
gem 'medium-editor-rails'
gem 'mini_magick'
gem 'newrelic_rpm'
gem 'oauth2'
gem 'pg'
gem 'premailer-rails'
gem 'puma'
gem 'pusher'
gem 'rails', '4.2.0'
gem 'react-rails', github: 'reactjs/react-rails'
gem 'redcarpet'
gem 'sass-rails', '~> 5'
gem 'sequential', '>= 0.1'
gem 'sidekiq'
gem 'sinatra', require: nil
gem 'stringex'
gem 'stripe'
gem 'uglifier', '>= 1.3.0'
gem 'underscore-rails'
gem 'unf'

source 'https://rails-assets.org' do
  gem 'rails-assets-animate.css',     '~> 3.2'
  gem 'rails-assets-jquery-autosize', '~> 1'
  gem 'rails-assets-js-md5',          '~> 1'
  gem 'rails-assets-handlebars',      '~> 3.0'
  gem 'rails-assets-moment',          '~> 2.9'
  gem 'rails-assets-showdown',        '~> 0.3'
end

group :development do
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'rest-client', require: false
  gem 'sinatra', require: false
  gem 'slim', require: false
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'faraday', '~> 0.9.0'
  gem 'ffaker', '~> 1.20'
  gem 'jasmine', github: 'pivotal/jasmine-gem'
  gem 'pry-byebug'
  gem 'json_spec', '~> 1.1'
  gem 'psych', '~> 2.0.5'
  gem 'rake'
  gem 'rspec-rails', '~> 3'
  gem 'timecop'
  gem 'vcr', '~> 2.9'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', require: nil
  gem 'poltergeist'
  gem 'webmock', '< 1.16'
end

group :development, :production do
  gem 'rails_12factor'
  gem 'font_assets'
end
