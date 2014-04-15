require "spec_helper"

describe User do
  before do
    @user = build(:user)
  end

  it "must be valid" do
    expect(@user).to be_valid
  end

  it 'can call username' do
    @user.save
    expect(@user.username).to be_nil
  end

end
