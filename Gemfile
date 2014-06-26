source 'https://rubygems.org'
source 'https://rails-assets.org'
ruby '2.1.1'

# Load environment variables first

gem 'dotenv-rails', groups: [:development, :test]

# Alphabetical list

gem 'active_model_serializers', github: 'rails-api/active_model_serializers'
gem 'analytics-ruby'
gem 'bootstrap-sass'
gem 'bourbon'
gem 'bugsnag'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'confyio'
gem 'curb'
gem 'devise', '~> 3.1'
gem 'devise-i18n'
gem 'devise_invitable', '~> 1.3'
gem 'doorkeeper'
gem 'elasticsearch-model'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 5.0'
gem 'jquery-rails'
gem 'medium-editor-rails'
gem 'mini_magick'
gem 'newrelic_rpm'
gem 'oauth2'
gem 'pg'
gem 'premailer-rails'
gem 'puma'
gem 'pusher'
gem 'rails', '~> 4.1.1'
gem 'rails-assets-animate.css'
gem 'rails-assets-jquery-autosize'
gem 'rails-assets-handlebars'
gem 'rails-assets-moment'
gem 'rails-assets-showdown'
gem 'redcarpet'
gem 'sass-rails', '~> 4.0.0'
gem 'sequential', '>= 0.1'
gem 'sidekiq'
gem 'stringex'
gem 'stripe'
gem 'uglifier', '>= 1.3.0'
gem 'unf'
gem 'awesome_print'
gem 'pry-rails'
gem 'react-rails', github: 'reactjs/react-rails'
gem 'underscore-rails'
gem 'rails-backbone'

group :development do
  gem 'quiet_assets'
  gem 'rest-client', require: false
  gem 'sinatra', require: false
  gem 'slim', require: false
end

group :development, :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'faraday', '~> 0.9.0'
  gem 'ffaker', '~> 1.20'
  gem 'jasmine', github: 'pivotal/jasmine-gem'
  gem 'jazz_hands'
  gem 'json_spec'
  gem 'pry'
  gem 'psych', '~> 2.0.5'
  gem 'rake'
  gem 'rspec-rails', '~> 2.99.0'
  gem 'timecop'
  gem 'vcr'
end

group :test do
  gem 'capybara'
  gem 'webmock', '< 1.16'
  gem 'codeclimate-test-reporter', require: nil
  gem 'poltergeist'
end

group :development, :production do
  gem 'rails_12factor'
  gem 'font_assets'
end
