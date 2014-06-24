require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
ENV["INCOMING_EMAIL_DOMAIN"] = 'helpful.io'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'sidekiq/testing'
require 'capybara/rails'
require 'capybara/rspec'
require 'webmock/rspec'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Sidekiq::Logging.logger = nil

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'vcr')
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'
end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.load_seed # loading seeds
  end

  config.render_views

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :request
  config.include AdminAuth

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.fixture_path = "#{Rails.root}/spec/fixtures"

  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.infer_spec_type_from_file_location!
end
