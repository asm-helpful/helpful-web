require 'active_support/concern'

module ConversationsSearch
  extend ActiveSupport::Concern

  # Public: Sorts conversations that have messages matching search results by the order
  # elasticsearch returns them.
  #
  # Returns an Array of Conversation models.  
  def search_conversations
    search_messages.map(&:conversation).uniq
  end

  # Public: Executes a search with the query
  #
  # Returns ids of matching models
  def search_messages
    Message.search(query: { match: { content: query } }).records.select {|m| m.account.id == account.id }
  end

  def search?
    query.present?
  end

  def clean_query(uncleaned_query)
    uncleaned_query.to_s.strip
  end
end
