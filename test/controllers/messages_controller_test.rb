require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  def test_index_success
    get :index
    assert_response :success
  end

end
