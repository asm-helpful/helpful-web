class ConversationsController < ApplicationController
  before_action :load_account

  def index
    if params['q'].blank?
      @conversations = @account.conversations.open.includes(:messages)

      # TODO move analytics to javascript?
      # TODO standardise analytics event names
      Analytics.track(user_id: current_user.id, event: 'Read Conversations Index') if signed_in?

    else
      @query = params['q'].to_s.strip

      message_ids = query_messages(@query)
      @conversations = @account.conversations.joins(:messages).where(messages: { id: message_ids })

      if signed_in?
        Analytics.track(user_id: current_user.id, event: 'Searched For', properties: { query: @query.to_s })
      end
    end
  end

  private

  def query_messages(query)
    response = elasticsearch.search body: { query: { match: { content: query } } }
    response['hits']['hits'].map { |x| x["_id"] }
  end

  def elasticsearch
    @es ||= Elasticsearch::Client.new hosts: [ ENV['ELASTICSEARCH_URL'] ]
  end

  def load_account
    @account = Account.find_by_slug!(params['account'])
  end
end
