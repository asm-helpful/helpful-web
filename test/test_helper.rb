ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "capybara/rails"
require "minitest/rails/capybara"
require "capybara/poltergeist"

# Uncomment for awesome colorful output
require "minitest/pride"

# Enabling Mocha after everything else...
require "mocha/setup"

Capybara.javascript_driver = :poltergeist
