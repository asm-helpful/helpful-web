# Searches or queries for archived conversations associated with the account and query
# if present.
class ConversationsArchive
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
      most_stale_conversations
    end
  end

  # Public: Returns all conversations with messages returned in the search
  # results
  #
  # Returns an ActiveRecord::Relation of Conversation models.
  def search_conversations
    preloaded_conversations.joins(:messages).where(messages: { id: search_messages })
  end

  # Public: Finds all the archived conversations and sorts them in order of least
  # recent message.
  #
  # Returns an Array of Conversation models.
  def most_stale_conversations
    archived_conversations.most_stale.to_a.uniq
  end

  # Public: Finds all the archived conversations associated with the account.
  #
  # Returns an ActiveRecord::Relation of Conversation models.
  def archived_conversations
    preloaded_conversations.archived
  end

  # Public: Executes a search with the query
  #
  # Returns ids of matching models
  def search_messages
    response = search_client.search(index: 'helpful', body: { query: { match: { content: query } } })
    response['hits']['hits'].map { |x| x['_id'] }
  end

  def preloaded_conversations
    account_conversations.includes(:messages)
  end

  def account_conversations
    account.conversations
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
end
