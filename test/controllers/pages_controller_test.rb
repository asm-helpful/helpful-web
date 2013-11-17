require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  def test_home_success
    get :home
    assert_response :success
  end

end
