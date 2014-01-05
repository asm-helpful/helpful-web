require 'test_helper'
include ActiveSupport::Testing::Assertions

describe ConversationsInbox do
  describe "#conversations" do
    it "searches for matching conversations if query is present" do
      inbox = ConversationsInbox.new(flexmock("Account"), "email problems")
      conversations = flexmock("Conversations")
      inbox = flexmock(inbox, search_conversations: conversations)

      assert_equal inbox.conversations, conversations
      assert_spy_called inbox, :search_conversations
    end

    it "finds the most stale conversations by default" do
      inbox = ConversationsInbox.new(flexmock("Account"))
      conversations = flexmock("Conversations")
      inbox = flexmock(inbox, most_stale_conversations: conversations)

      assert_equal inbox.conversations, conversations
      assert_spy_called inbox, :most_stale_conversations
    end
  end

  describe "#search_conversations" do
    it "returns the conversations with messages returned in the search results" do
      conversation = FactoryGirl.create(:conversation)
      message = FactoryGirl.create(:message, conversation: conversation)

      inbox = ConversationsInbox.new(flexmock("Account"))
      messages = [message.id]
      conversations = Conversation.where(id: conversation.id)
      inbox = flexmock(inbox, search_messages: messages, preloaded_conversations: conversations)

      assert_equal inbox.search_conversations, [conversation]
    end
  end

  describe "#most_stale_conversations" do
    it "sorts the open conversations by least recent message" do
      inbox = ConversationsInbox.new(flexmock("Account"))
      conversations = flexmock("Conversations", most_stale: [])
      inbox = flexmock(inbox, open_conversations: conversations)

      inbox.most_stale_conversations

      assert_spy_called conversations, :most_stale
    end
  end

  describe "#open_conversations" do
    it "only finds the conversations with an open status" do
      inbox = ConversationsInbox.new(flexmock("Account"))
      conversations = flexmock("Conversations", open: [])
      inbox = flexmock(inbox, preloaded_conversations: conversations)

      inbox.open_conversations

      assert_spy_called conversations, :open
    end
  end

  describe "#search_messages" do
    it "asks the search client for messages matching the query and returns the ids" do
      inbox = ConversationsInbox.new(flexmock("Account"), "email problems")
      search_client = flexmock("SearchClient", search: { 'hits' => { 'hits' => [{ '_id' => 1 }] } })
      inbox = flexmock(inbox, search_client: search_client)

      assert_equal inbox.search_messages, [1]
    end
  end

  describe "#preloaded_conversations" do
    it "preloads all messages ahead of time" do
      inbox = ConversationsInbox.new(flexmock("Account"))
      conversations = flexmock("Conversations", includes: [])
      inbox = flexmock(inbox, account_conversations: conversations)

      inbox.preloaded_conversations

      assert_spy_called conversations, :includes, :messages
    end
  end

  describe "#account_conversations" do
    it "finds the conversations associated with the account" do
      account = flexmock("Account", conversations: [])
      inbox = ConversationsInbox.new(account)

      inbox.account_conversations

      assert_spy_called account, :conversations
    end
  end

  describe "#search?" do
    it "knows if conversations are being searched with a query" do
      inbox = ConversationsInbox.new(flexmock("Account"), "email problems")
      assert inbox.search?

      inbox = ConversationsInbox.new(flexmock("Account"))
      refute inbox.search?
    end
  end

  describe "#clean_query" do
    it "remotes whitespace from a query" do
      query = "  email problems     "
      inbox = ConversationsInbox.new(flexmock("Account"), query)
      assert_equal inbox.clean_query(query), "email problems"
    end
  end
end
