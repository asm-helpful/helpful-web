require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Helpful
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << File.join(config.root, 'lib')
    config.autoload_paths << File.join(config.root, 'app', 'policies')

    # Use MiniTest::Spec and FactoryGirl
    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework :rspec, spec: true, fixture: false
    end

    config.action_mailer.preview_path = Rails.root.join('spec', 'mailers', 'previews')

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = true

    # Stop assets from accessing models. Useful for Heroku and Devise.
    config.assets.initialize_on_precompile = false

    # TODO Remove once the Embeddable form is in a seperate repo
    config.assets.precompile << 'embed.css'
    config.assets.precompile << 'embed.js'

    config.to_prepare do
      Devise::Mailer.layout "email"
    end

    console do
      config.console = Pry
    end

    config.after_initialize do
      Hirb.enable if Rails.env.development? || Rails.env.test?
    end
  end
end
