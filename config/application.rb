require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

# Permits the use of default env variables in dev/test, but requires that they be set for production to work correctly
# This method must exist before the environment initializers that use it
def easy_env_default(key, default = 'insecure')
  ENV[key.to_s] || (Rails.env.production? ? raise("ENV variable must exist: #{key}") : default)
end

module Supportly
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << File.join(config.root, 'lib')


    # Use MiniTest::Spec and FactoryGirl
    config.generators do |g|
      g.test_framework :mini_test, spec: true, fixture: false
    end


    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
