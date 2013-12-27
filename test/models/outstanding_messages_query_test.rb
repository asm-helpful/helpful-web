require 'test_helper'
include ActiveSupport::Testing::Assertions

describe OutstandingMessagesQuery do
  before do
    @conversation = FactoryGirl.create(:conversation)
    @query = OutstandingMessagesQuery.new(@conversation)
  end

  describe "#outstanding_customer_messages" do
    before do
      @agent = FactoryGirl.create(:person)
      @agent_user = FactoryGirl.create(:user, person: @agent)
      FactoryGirl.create(:membership, role: 'agent', user: @agent_user, account: @conversation.account)

      @customer = FactoryGirl.create(:person)
      @customer_user = FactoryGirl.create(:user, person: @customer)
      FactoryGirl.create(:membership, role: 'customer', user: @customer_user, account: @conversation.account)
    end

    it "returns outstanding messages authored by customers" do
      agent_message = FactoryGirl.create(:message, person: @agent, conversation: @conversation)
      customer_message = FactoryGirl.create(:message, person: @customer, conversation: @conversation)
      assert_equal @query.outstanding_customer_messages, [customer_message]
    end
  end

  describe "#oustanding_messages" do
    it "returns messages without an agent responded timestamp" do
      responded_message = FactoryGirl.create(:message, conversation: @conversation, agent_responded_at: Time.now)
      outstanding_message = FactoryGirl.create(:message, conversation: @conversation)
      assert_equal @query.outstanding_messages, [outstanding_message]
    end
  end

  describe "#customer_message?" do
    before do
      @customer = FactoryGirl.create(:person)
      @customer_user = FactoryGirl.create(:user, person: @customer)
      FactoryGirl.create(:membership, role: 'customer', user: @customer_user, account: @conversation.account)
    end

    it "checks if the author of the message is a customer" do
      message = FactoryGirl.create(:message, person: @customer)
      assert @query.customer_message?(message)
    end
  end
end
