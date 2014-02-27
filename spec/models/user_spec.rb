require "spec_helper"

describe User do
  before do
    @user = build(:user)
  end

  it "must be valid" do
    expect(@user).to be_valid
  end

end
