require 'spec_helper'

describe MessageMailer, :created do
  let(:user) { create(:user_with_account) }
  let(:account) { user.accounts.first }
  let(:recipient) { create(:person, user: user) }
  let(:message_id) { '123@example.mail' }
  let(:conversation) { create(:conversation, account: account) }
  let(:message) {
    create(:message, person: user.person,
                     message_id: message_id,
                     conversation: conversation)
  }

  describe "#forward" do

    subject { described_class.forward(message, recipient) }

    it "delivers" do
      subject.deliver_now
      expect(ActionMailer::Base.deliveries).to be_present
    end

    it "has the correct recipient" do
      expect(subject.to).to include(recipient.email)
    end

    it "has the correct message_id" do
      expect(subject.message_id).to eq(message_id)
    end

    it "has the correct in-reply-to header" do
      m1 = create(:message, message_id: 'foo@test', conversation: conversation)
      message.in_reply_to = m1
      expect(subject.in_reply_to).to eq(m1.message_id)
    end

    it "has the correct from address" do
      expect(subject.from.first).to eq("#{message.account.slug}@helpful.io")
    end

    it "has the correct from display_name" do
      expect(subject[:from].value).to eq(message.from_address.to_s)
    end

    it "includes a link to the conversation" do
      pending "TODO"
      conversation_path = account_conversation_path(message.account, message.conversation)
      expect(subject.body.encoded).to include(conversation_path)
    end

    context "when using markdown to reply" do
      let(:message) { create(:message, conversation: conversation, content: "<h3>Heading</h3>") }

      it 'formats the body in html' do
        expect(subject.body.encoded).to match "<h3>Heading</h3>"
      end
    end

  end
end
