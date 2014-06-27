# Searches or queries for conversations associated with the account and query
# if present.
class ConversationsInbox
  include ConversationsMethods
  include ConversationsSearch

  attr_accessor :account, :user, :query

  def initialize(account, user, query = nil)
    self.account = account
    self.user = user
    self.query = clean_query(query)
  end

  # Public: Returns conversations matching search results if present.
  # Otherwise, the conversations are returned in order of least recent message.
  #
  # Returns an Array or ActiveRecord::Relation of Conversation models.
  def conversations
    if search?
      search_conversations
    else
      open_conversations
    end
  end

  # Public: Finds the next conversation in the queue after the
  # conversation argument
  #
  # Returns a Conversation model or nil if the argument is the last
  # conversation in the inbox
  def next_conversation(conversation)
    index = queue_index(conversation)
    open_conversations[index + 1] if index
  end

  # Returns a Conversation model or nil if the argument is the first
  # conversation in the inbox
  def previous_conversation(conversation)
    index = queue_index(conversation)
    open_conversations[index - 1] if index && index > 0
  end
  
  def queue_index(conversation)
    open_conversations.index { |c| c == conversation }
  end

  # Public: Finds all the open conversations associated with the account.
  #
  # Returns an ActiveRecord::Relation of Conversation models.
  def open_conversations
    conversations = preloaded_conversations.unresolved
    conversations = conversations.unassigned_or_assigned_to(user)
    conversations = conversations.with_messages
    conversations = conversations.order('conversations.updated_at DESC')
    conversations
  end
end
