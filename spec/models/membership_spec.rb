require "spec_helper"

describe Membership do
  before do
    @membership = FactoryGirl.build(:membership)
  end

  it "must be valid" do
    expect(@membership).to be_valid
  end

  describe "role helpers" do
    it "returns true if the membership has the matching role" do
      @membership.role = 'owner'
      assert @membership.owner?

      @membership.role = 'agent'
      assert @membership.agent?
    end
  end
end
