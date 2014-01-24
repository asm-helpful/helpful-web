require 'test_helper'
include ActiveSupport::Testing::Assertions

describe ConversationsArchive do
  describe "#conversations" do
    it "searches for matching conversations if query is present" do
      archive = ConversationsArchive.new(flexmock("Account"), "email problems")
      conversations = flexmock("Conversations")
      archive = flexmock(archive, search_conversations: conversations)

      assert_equal archive.conversations, conversations
      assert_spy_called archive, :search_conversations
    end

    it "finds the most stale conversations by default" do
      archive = ConversationsArchive.new(flexmock("Account"))
      conversations = flexmock("Conversations")
      archive = flexmock(archive, most_stale_conversations: conversations)

      assert_equal archive.conversations, conversations
      assert_spy_called archive, :most_stale_conversations
    end
  end

  describe "#search_conversations" do
    it "returns the conversations with messages returned in the search results" do
      conversation = FactoryGirl.create(:conversation)
      message = FactoryGirl.create(:message, conversation: conversation)

      archive = ConversationsArchive.new(flexmock("Account"))
      messages = [message.id]
      conversations = Conversation.where(id: conversation.id)
      archive = flexmock(archive, search_messages: messages, preloaded_conversations: conversations)

      assert_equal archive.search_conversations, [conversation]
    end
  end

  describe "#most_stale_conversations" do
    it "sorts the archived conversations by least recent message" do
      archive = ConversationsArchive.new(flexmock("Account"))
      conversations = flexmock("Conversations", most_stale: [])
      archive = flexmock(archive, archived_conversations: conversations)

      archive.most_stale_conversations

      assert_spy_called conversations, :most_stale
    end
  end

  describe "#archived_conversations" do
    it "only finds the conversations with an archived status" do
      archive = ConversationsArchive.new(flexmock("Account"))
      conversations = flexmock("Conversations", archived: [])
      archive = flexmock(archive, preloaded_conversations: conversations)

      archive.archived_conversations

      assert_spy_called conversations, :archived
    end
  end

  describe "#search_messages" do
    it "asks the search client for messages matching the query and returns the ids" do
      archive = ConversationsArchive.new(flexmock("Account"), "email problems")
      search_client = flexmock("SearchClient", search: { 'hits' => { 'hits' => [{ '_id' => 1 }] } })
      archive = flexmock(archive, search_client: search_client)

      assert_equal archive.search_messages, [1]
    end
  end

  describe "#preloaded_conversations" do
    it "preloads all messages ahead of time" do
      archive = ConversationsArchive.new(flexmock("Account"))
      conversations = flexmock("Conversations", includes: [])
      archive = flexmock(archive, account_conversations: conversations)

      archive.preloaded_conversations

      assert_spy_called conversations, :includes, :messages
    end
  end

  describe "#account_conversations" do
    it "finds the conversations associated with the account" do
      account = flexmock("Account", conversations: [])
      archive = ConversationsArchive.new(account)

      archive.account_conversations

      assert_spy_called account, :conversations
    end
  end

  describe "#search?" do
    it "knows if conversations are being searched with a query" do
      archive = ConversationsArchive.new(flexmock("Account"), "email problems")
      assert archive.search?

      archive = ConversationsArchive.new(flexmock("Account"))
      refute archive.search?
    end
  end

  describe "#clean_query" do
    it "remotes whitespace from a query" do
      query = "  email problems     "
      archive = ConversationsArchive.new(flexmock("Account"), query)
      assert_equal archive.clean_query(query), "email problems"
    end
  end
end
