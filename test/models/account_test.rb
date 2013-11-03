require 'test_helper'

describe Account do
  before do
    @account = Account.new
  end

  it "must be valid" do
    @account.valid?.must_equal true
  end

  it "must have a unique name" do
    Account.create name: 'unique'
    @account.name = 'unique'

    assert_raises(ActiveRecord::RecordNotUnique) do
      @account.save
    end
  end
end
