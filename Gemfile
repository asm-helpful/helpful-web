source 'https://rubygems.org'
ruby '2.0.0'

gem 'jquery-rails'
gem 'pg'
gem 'puma'
gem 'rails', '4.0.1'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'sidekiq'
gem 'devise', '~> 3.1'

group :development, :test do
  gem 'rake'

  gem 'minitest-rails-capybara', '~> 0.10.0'
  gem 'minitest-rails', '~> 0.9.2'
  gem 'mocha', '~> 0.14.0', require: false

  gem 'capybara', '~> 2.1.0'
  gem 'capybara_minitest_spec', '~> 1.0.1'

  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'poltergeist', '~> 1.4.1'

  gem 'ffaker', '~> 1.20'
end

group :production do
  gem 'rails_12factor'
end

group :development do
  #For sidekiq admin support
  gem 'sinatra', require: false
  gem 'slim'

  gem 'minitest-spec-rails'
end
