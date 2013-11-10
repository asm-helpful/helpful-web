require 'test_helper'

describe Account do
  before do
    @account = FactoryGirl.build(:account)
  end

  it "must be valid" do
    @account.valid?.must_equal true
  end

  it "must have a unique slug" do
    Account.create name: 'unique', slug: 'unique'
    @account.name = 'unique'
    @account.slug = 'unique'

    assert_raises(ActiveRecord::RecordNotUnique) do
      @account.save
    end
  end
  
  it "must have a web_hook_url field" do
    assert Account.column_names.include? "web_hook_url"
  end
end
