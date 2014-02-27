require 'spec_helper'

describe PagesController do
  it "home is ok" do
    get :home
    assert_equal response.status, 200
  end
end
