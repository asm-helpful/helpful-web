source 'https://rubygems.org'
source 'https://rails-assets.org'
ruby '2.1.1'

# Load environment variables first

gem 'dotenv-rails', groups: [:development, :test]

# Alphabetical list

gem 'active_model_serializers'
gem 'analytics-ruby'
gem 'bootstrap-sass'
gem 'bourbon'
gem 'bugsnag'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'curb'
gem 'devise', '~> 3.1'
gem 'devise_invitable', '~> 1.3'
gem 'devise-i18n'
gem 'doorkeeper'
gem 'elasticsearch-model'
gem 'friendly_id', '~> 5.0'
gem 'jquery-rails'
gem 'jquery-textcomplete-rails'
gem 'oauth2'
gem 'pg'
gem 'premailer-rails'
gem 'puma'
gem 'pusher'
gem 'rails', '~> 4.1.0.rc1'
gem 'rails-assets-jquery-autosize'
gem 'redcarpet'
gem 'sass-rails', '~> 4.0.0'
gem 'sequential', '>= 0.1'
gem 'sidekiq'
gem 'stringex'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'unf'

group :development do
  gem 'quiet_assets'
  gem 'rest-client', require: false
  gem 'sinatra', require: false
  gem 'slim', require: false
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'ffaker', '~> 1.20'
  gem 'rake'
  gem 'rspec-rails', '~> 3.0.0.beta2'
  gem 'pry'
  gem 'timecop'
  gem 'jasmine', github: 'pivotal/jasmine-gem'
  gem 'vcr'
  gem 'faraday', '~> 0.9.0'
  gem 'psych', '~> 2.0.5'
  gem 'database_cleaner'
end

group :test do
  gem 'capybara'
  gem 'webmock', '< 1.16'
end

group :development, :production do
  gem 'rails_12factor'
end
