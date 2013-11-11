require 'test_helper'

describe Conversation do
  before do
    @conversation = Conversation.new
  end

  it "is valid" do
    assert @conversation.valid?
  end

  it "should not be archived by default" do
    assert !@conversation.archived?
  end

  it "should be archived after archive" do
    conversation = FactoryGirl.create :conversation
    conversation.archive
    assert conversation.archived?
  end

  it "should only return unarchived conversations" do
    FactoryGirl.create :conversation
    FactoryGirl.create :archived_conversation
    Conversation.open.each do |c|
      assert !c.archived?
    end
  end

  it "adds the correct conversation number on create based on account_id" do
    @account = FactoryGirl.create(:account)

    @conversation_1 = FactoryGirl.create(:conversation, account: @account)
    assert_equal 1, @conversation_1.number

    @conversation_2 = FactoryGirl.create(:conversation, account: @account)
    assert_equal 2, @conversation_2.number

    @conversation_3 = FactoryGirl.create(:conversation)
    assert_equal 1, @conversation_3.number
  end
end
