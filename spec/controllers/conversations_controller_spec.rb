require 'spec_helper'

describe ConversationsController do
  let!(:account) { create(:account) }
  let!(:conversation) { create(:conversation, account: account) }
  let!(:user) { create(:user_with_account, account: account) }

  before { sign_in(user) }

  it 'archives a conversation' do
    post :update,
      {
        account_id: account.slug,
        id: conversation.number,
        conversation: {
          archive: true
        }
      }

    conversation.reload

    expect(conversation).to be_archived
  end

  it 'unarchives a conversation' do
    conversation.archive!

    post :update,
      {
        account_id: account.slug,
        id: conversation.number,
        conversation: {
          unarchive: true
        }
      }

    conversation.reload

    expect(conversation).not_to be_archived
  end

  it 'moves a conversation to the bottom of the queue' do
    Timecop.travel(5.minutes.from_now)

    post :update,
      {
        account_id: account.slug,
        id: conversation.number,
        conversation: {
          respond_later: true
        }
      }

    conversation.reload

    expect(conversation.updated_at).to be > conversation.created_at
  end
end
