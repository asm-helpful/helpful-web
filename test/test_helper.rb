ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "webmock/test_unit"

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include WebMock::API

  alias_method :teardown_without_webmock, :teardown

  def teardown_with_webmock
    teardown_without_webmock
    WebMock.reset!
  end

  alias_method :teardown, :teardown_with_webmock

end

class ActionController::TestCase
  include Devise::TestHelpers
end
