require 'test_helper'

describe PagesController do
  test "home is ok" do
    get :home
    assert_equal response.status, 200
  end
end
