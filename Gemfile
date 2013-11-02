source 'https://rubygems.org'
ruby '2.0.0'

gem 'jquery-rails'
gem 'pg'
gem 'puma'
gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'rake'
end

group :production do
  gem 'rails_12factor'
end

gem 'sidekiq'
#For sidekiq admin support
group :development do 
  gem 'sinatra', require: false
  gem 'slim'
end