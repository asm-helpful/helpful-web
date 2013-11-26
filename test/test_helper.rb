ENV["RAILS_ENV"] = "test"
ENV['ELASTICSEARCH_URL'] = setting_to_nil_to_disable_search_in_test = nil

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

require "minitest/mock"
require "webmock/minitest"

require "minitest/reporters"

require 'flexmock/test_unit'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true)

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase
  include Devise::TestHelpers
end

Mail.defaults do
  delivery_method :test
end

require 'sidekiq/testing'
Sidekiq::Testing.fake!