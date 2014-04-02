# Searches or queries for archived conversations associated with the account and query
# if present.
class ConversationsArchive
  include ConversationsMethods
  include ConversationsSearch
  
  attr_accessor :account, :query

  def initialize(account, query = nil)
    self.account = account
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
      most_recent_conversations
    end
  end

  # Public: Finds all the archived conversations and sorts them in order of least
  # recent message.
  #
  # Returns an Array of Conversation models.
  def most_recent_conversations
    archived_conversations.most_recent.to_a.uniq
  end

  # Public: Finds all the archived conversations associated with the account.
  #
  # Returns an ActiveRecord::Relation of Conversation models.
  def archived_conversations
    preloaded_conversations.archived
  end
end
