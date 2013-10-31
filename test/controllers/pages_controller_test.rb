require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  def test_home_ok
    get :home
    assert_response :ok
  end

end
