require 'spec_helper'

describe ConversationsController do
  let!(:account) { create(:account) }
  let!(:next_conversation) { create(:conversation_with_messages, account: account) }
  let!(:conversation) { create(:conversation_with_messages, account: account) }
  let!(:archived_conversation) { create(:conversation_with_messages, account: account, archived: true) }
  let!(:user) { create(:user_with_account, account: account) }

  before { sign_in(user) }

  describe '#update' do
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
      expect(response).to redirect_to inbox_account_conversations_path(account)
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
      expect(response).to redirect_to inbox_account_conversations_path(account)
    end

    it 'moves a conversation to the bottom of the queue' do
      post :update,
        {
          account_id: account.slug,
          id: conversation.number,
          conversation: {
            respond_later: true
          }
        }

      conversation.reload

      expect(conversation.respond_laters).not_to be_empty
    end
  end

  describe '#search', vcr: true do
    let!(:messages) {
      [
        create(:message, content: 'This is broken', account: account), 
        create(:message, content: 'Hi, my name is Ben. I need help', account: account)
      ]
    }

    let(:ids) {
      [
        'c795dcb6-8f64-4c1d-888d-c0064153f892',
        '4b4f2e44-0462-41f1-9861-cedbaf377a99'
      ]
    }

    before {
      messages.zip(ids).each do |message, id|
        message.id = id
        message.save!
      end

      Message.import
    }

    it 'returns search results as json' do
      post :search,
        {
          account_id: account.slug,
          q: 'Ben',
          format: :json
        }

      expect(JSON.parse(response.body)['conversations'].length).to eq(1)
      expect(JSON.parse(response.body)['conversations'][0]['messages'][0]['body']).to include('Ben')
    end
  end
end
