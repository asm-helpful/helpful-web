require 'spec_helper'

describe ConversationsArchive do
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

  describe "search" do
    it "receives multiple messages and conversations" do
      archive = ConversationsArchive.new(account, 'test')

      expect(archive.search_messages.to_a).to match_array(messages)
      expect(archive.conversations).to match_array(conversations)
    end

    it "receives specific conversations by message content" do
      archive = ConversationsArchive.new(account, '0')

      expect(archive.search_messages.first).to eq(messages.first)
      expect(archive.conversations.first).to eq(conversations.first)
    end
  end

end
