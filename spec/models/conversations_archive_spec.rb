require 'spec_helper'

describe ConversationsArchive do
  let!(:test_message){ create(:message, content: 'test message') }
  let!(:account) { create(:account) }

  let!(:conversations) {
    Array.new(3) do
      create(:conversation, account: account)
    end
  }

  let!(:messages) {
    Array.new(3) do |i|
      message = create(
        :message,
        conversation: conversations[i],
        content: "test #{i}"
      )

      message.id = "c91d36fb-c406-4a06-a9b0-808c64b80e8#{i}"
      message.save!

      message
    end
  }

  before { Message.import(force: true, refresh: true) }

  describe "search", vcr: true do

    context "when requsting messages" do
      let(:archive) { ConversationsArchive.new(account, 'test') }

      it "receives multiple messages and conversations" do
        expect(archive.search_messages.to_a).to match_array(messages)
        expect(archive.conversations).to match_array(conversations)
      end

      it 'only searches messages within the account' do
        expect(archive.search_messages.to_a).to_not include(test_message)
      end
    end

    context "when requesting conversations" do
      it "receives specific conversations by message content" do
        archive = ConversationsArchive.new(account, '0')

        expect(archive.search_messages.first).to eq(messages.first)
        expect(archive.conversations.first).to eq(conversations.first)
      end
    end
  end
end
