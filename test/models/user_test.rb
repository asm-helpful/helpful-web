require "test_helper"

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end

  it "must be valid" do
    @user.valid?.must_equal true
  end

end
