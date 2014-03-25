require 'active_support/concern'

module ConversationsSearch
  extend ActiveSupport::Concern

  # Public: Sorts conversations that have messages matching search results by the order
  # elasticsearch returns them.
  #
  # Returns an Array of Conversation models.  
  def search_conversations
    search_messages.map do |message_id| 
      search_conversations_unsorted.find { |c| c.contains_message_id?(message_id) }
    end.compact.uniq
  end

  # Public: Executes a search with the query
  #
  # Returns ids of matching models
  def search_messages
    response = search_client.search(index: Rails.env.test? ? 'helpful-test' : 'helpful', body: { query: { match: { content: query } } })
    response['hits']['hits'].map { |x| x['_id'] }
  end

  def search?
    query.present?
  end

  def clean_query(uncleaned_query)
    uncleaned_query.to_s.strip
  end

  def search_client
    Elasticsearch::Client.new(hosts: [ENV['ELASTICSEARCH_URL']])
  end

  private
  # Private: Returns all conversations with messages returned in the search
  # results
  #
  # Returns an ActiveRecord::Relation of Conversation models.
  def search_conversations_unsorted
    preloaded_conversations.joins(:messages).where(messages: { id: search_messages })
  end
end
