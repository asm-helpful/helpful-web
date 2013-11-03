require 'test_helper'

describe MessagesController do
  test "index is ok" do
    get :index
    assert_equal response.status, 200
  end
end
