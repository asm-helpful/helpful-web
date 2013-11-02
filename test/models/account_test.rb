require 'test_helper'

describe Account do
  before do
    @account = Account.new
  end

  it "must be valid" do
    @account.valid?.must_equal true
  end
end