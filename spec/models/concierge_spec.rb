require 'spec_helper'
include ActiveSupport::Testing::Assertions

describe Concierge do
  before do
    @account = FactoryGirl.create(:account)
    @conversation = FactoryGirl.build(:conversation, account: @account)
  end

  describe "#find_conversation" do
    it "should find a conversation based on params[:conversation]" do
      @conversation.save
      params = { conversation: @conversation.number }
      assert_equal @conversation.id, Concierge.new(@account, params).find_conversation.id
    end

    it "should find a conversation based on params[:recipient]" do
      @conversation.save
      params = { recipient: @conversation.mailbox_email.to_s }
      assert_equal @conversation.id, Concierge.new(@account, params).find_conversation.id
    end

    it "should prefer params[:conversation] over params[:recipient]" do
      @conversation.save
      @conversation_2 = FactoryGirl.create(:conversation)
      params = {
        conversation: @conversation.number,
        recipient:    @conversation_2.mailbox_email.to_s
      }
      assert_equal @conversation.id, Concierge.new(@account, params).find_conversation.id
    end

    it "should create a new conversation when one cannot be found" do
      @conversation.save
      params = { conversation: 10000000 }
      assert_difference "@account.conversations.count" do
        Concierge.new(@account, params).find_conversation
      end
    end

    it "should create a new conversation when one cannot be found" do
      @conversation.save
      params = { recipient: @conversation.mailbox_email.to_s }
      @conversation.delete
      assert_difference "@account.conversations.count" do
        Concierge.new(@account, params).find_conversation
      end
    end

    it "should not create a new conversation when one can be found" do
      @conversation.save
      params = { conversation: @conversation.number }
      assert_no_difference "@account.conversations.count" do
        Concierge.new(@account, params).find_conversation
      end
    end
  end
end
