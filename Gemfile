source 'https://rubygems.org'
ruby '2.0.0'

# Alphabetical list

gem 'active_model_serializers'
gem 'analytics-ruby', '<1.0'
gem 'bourbon'
gem 'bugsnag'
gem 'curb'
gem 'devise', '~> 3.1'
gem 'friendly_id', '~> 5.0'
gem 'elasticsearch', '~> 0.4.1'
gem 'jquery-rails'
gem 'mailman', require: false
gem 'pg'
gem 'puma'
gem 'rails', '4.0.1'
gem 'rails_stdout_logging', group: [:development, :production]
gem 'sass-rails', '~> 4.0.0'
gem 'sequential', '>= 0.0.3'
gem 'sidekiq'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'quiet_assets'
  gem 'sinatra', require: false
  gem 'slim', require: false
end

group :test do
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'minitest-rails', '~> 0.9.2'
  gem 'minitest-reporters'
  gem 'webmock', '~> 1.15'
  gem "flexmock"
end

group :development, :test do
  gem 'rake'
  gem 'dotenv-rails'
  gem 'ffaker', '~> 1.20'
end

group :production do
  gem 'rails_12factor'
end
