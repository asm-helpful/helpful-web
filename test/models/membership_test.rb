require "test_helper"

describe Membership do
  before do
    @membership = FactoryGirl.build(:membership)
  end

  it "must be valid" do
    @membership.valid?.must_equal true
  end
end
