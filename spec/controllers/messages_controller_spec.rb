require 'spec_helper'

describe MessagesController do
  let!(:account) { create(:account) }
  let!(:user) { create(:user) }
  let!(:person) { create(:person, user: user, account: account) }
  let!(:membership) { create(:membership, user: user, account: account, role: 'agent') }
  let!(:conversation) { create(:conversation, account: account) }

  before do
    sign_in(user)
  end

  it 'adds a message to a conversation' do
    post :create,
      {
        account_id: account.slug,
        message: {
          content: 'I need help please.',
          conversation_id: conversation.id
        }
      }

    message = conversation.messages.last

    expect(message).to be_present
    expect(message.person).to eq(person)
    expect(response).to redirect_to(account_conversation_path(account, conversation))
  end

  it "adds a message to the conversation and archives it" do
    post :create,
      {
        account_id: account.slug,
        archive_conversation: true,
        message: {
          content: 'I need help please.',
          conversation_id: conversation.id
        }
      }
    message = conversation.messages.last
    
    expect(message).to be_present
    expect(message.person).to eq(person)
    expect(response).to redirect_to(inbox_account_conversations_path(account))
    expect(flash[:notice]).to eq("The conversation has been archived and the message sent.")
  end
end
