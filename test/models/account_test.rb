require 'test_helper'

describe Account do
  before do
    @account = FactoryGirl.build(:account)
  end

  it "must be valid" do
    @account.valid?.must_equal true
  end
end
