require "test_helper"

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end

  it "must be valid" do
    @user.valid?.must_equal true
  end

  describe "membership detection" do

    it "determines when the user is NOT an agent" do
      @membership = FactoryGirl.create(:membership, role: 'customer')
      @user = @membership.user

      assert !@user.agent_or_higher?(@membership.account_id)
    end

    it "determines when the user is an agent" do
      @membership = FactoryGirl.create(:membership, role: 'agent')
      @user = @membership.user

      assert @user.agent_or_higher?(@membership.account_id)
    end
  end

end
