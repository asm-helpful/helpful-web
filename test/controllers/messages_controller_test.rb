require 'test_helper'

class MessagesControllerTest < ActionController::TestCase

  def test_index_ok
    get :index
    assert_response :ok
  end

end
