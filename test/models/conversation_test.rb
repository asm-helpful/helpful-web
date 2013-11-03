require 'test_helper'

describe Conversation do
  before do
    @conversation = FactoryGirl.build(:conversation)
  end

  it "is valid" do
    assert @conversation.valid?
  end

  it "adds the correct conversation number on create based on account_id" do
    @account = FactoryGirl.create(:account)
    
    @conversation.account = @account
    @conversation.save
    
    assert_equal 1, @conversation.number
    
    @conversation_2 = FactoryGirl.create(:conversation, account: @account)
    @conversation_3 = FactoryGirl.create(:conversation)
    
    assert_equal 2, @conversation_2.number
    
    assert_equal 1, @conversation_3.number
  end
end
