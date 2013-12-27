require "test_helper"

describe Membership do
  before do
    @membership = FactoryGirl.build(:membership)
  end

  it "must be valid" do
    @membership.valid?.must_equal true
  end

  describe "role helpers" do
    it "returns true if the membership has the matching role" do
      @membership.role = 'owner'
      assert @membership.owner?

      @membership.role = 'agent'
      assert @membership.agent?

      @membership.role = 'customer'
      assert @membership.customer?
    end
  end
end
