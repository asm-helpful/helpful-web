require 'spec_helper'

describe MessageMailer, :created do
  let!(:user) { create(:user_with_account) }
  let!(:recipient) { create(:person, user: user) }
  let!(:message) { create(:message, account: user.accounts.first) }

  it "delivers" do
    MessageMailer.created(message.id, recipient.id).deliver
    expect(ActionMailer::Base.deliveries).to be_present
  end

  it "has the correct recipient" do
    email = MessageMailer.created(message.id, recipient.id)
    expect(email.to).to include(recipient.email)
  end

  it "has the correct reply_to address" do
    email = MessageMailer.created(message.id, recipient.id)
    expect(email.reply_to.first).to eq(message.conversation.mailbox_email.address.to_s)
  end

  it "has the correct reply_to display_name" do
    email = MessageMailer.created(message.id, recipient.id)
    reply_to_display_name = email[:reply_to].addrs.first.display_name.to_s
    expect(reply_to_display_name).to eq(message.conversation.account.name)
  end

  it "has the correct from address" do
    email = MessageMailer.created(message.id, recipient.id)
    expect(email.from.first).to eq("notifications@helpful.io")
  end

  it "has the correct from display_name" do
    email = MessageMailer.created(message.id, recipient.id)
    display_name = email[:from].addrs.first.display_name.to_s
    expect(display_name).to eq(message.person.name)
  end

  it "includes a link to the conversation" do
    email = MessageMailer.created(message.id, recipient.id)
    conversation_path = account_conversation_path(message.account, message.conversation)
    expect(email.body.encoded).to include(conversation_path)
  end
end
