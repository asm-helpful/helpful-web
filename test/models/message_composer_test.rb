require 'test_helper'
include ActiveSupport::Testing::Assertions

describe MessageComposer do
  before do
    @user = FactoryGirl.create(:user)
    @person = FactoryGirl.create(:person, user: @user)
    @conversation = FactoryGirl.create(:conversation)
    FactoryGirl.create(:membership, user: @user, account: @conversation.account, role: 'agent')

    @customer_user = FactoryGirl.create(:user)
    @customer = FactoryGirl.create(:person, user: @customer_user)
    FactoryGirl.create(:membership, user: @customer_user, account: @conversation.account, role: 'customer')

    @outstanding_message = FactoryGirl.create(:message, person: @customer, conversation: @conversation)
    @content = Faker::Lorem.paragraph(3)
  end

  describe "#compose" do
    it "creates a new message" do
      message_composer = MessageComposer.new(@person, @conversation)
      message = message_composer.compose(@content)
      assert_equal message.person, @person
      assert_equal message.conversation, @conversation
      assert_equal message.content, @content
    end

    it "sets the timestamp of outstanding message when replying" do
      message_composer = MessageComposer.new(@person, @conversation)
      message = message_composer.compose(@content)
      [@outstanding_message, message].each(&:reload)
      assert_equal @outstanding_message.agent_responded_at, message.created_at
    end
  end
end
