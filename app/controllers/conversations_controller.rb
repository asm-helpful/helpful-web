class ConversationsController < ApplicationController
  before_action :load_account

  def index
    if params['q'] and not params['q'].empty?
      @query = params['q']
      es = Elasticsearch::Client.new hosts: [ ENV['ELASTICSEARCH_URL'] ]
      response = es.search body: { query: { match: { content: @query.to_s } } }
      ids = response['hits']['hits'].map { |x| x["_id"] }
      @conversations = @account.conversations.joins(:messages).where(messages: {:id => ids})
    else
      @conversations = @account.conversations.open.includes(:messages)
    end
  end

  private

  def load_account
    @account = Account.first! # simpfy until for now
  end

end
