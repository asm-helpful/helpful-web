class ConversationsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_account

  before_action :find_account
  before_action :find_conversation, only: [:show]


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

    @conversation = @conversations.first
  end

  def show
    @conversations = @account.conversations.open.includes(:messages)
    @conversation
  end

  def update
    @conversation = Conversation.find(params[:id])
    respond_to do |format|
      if @conversation.update_attributes(conversation_params)
        format.json { head :no_content }
      else
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def ensure_account
    if signed_in? && params[:account].blank?
      redirect_to conversations_path(current_account)
    end
  end

  def find_account
    @account = Account.find_by_slug!(params.fetch(:account))
  end

  def find_conversation
    @conversation = @account.conversations.where(number: params.fetch(:id)).first!
  end

  private

  def conversation_params
    params.require(:conversation).permit(:archive, :id)
  end

  def query_messages(query)
    response = elasticsearch.search body: { query: { match: { content: query } } }
    response['hits']['hits'].map { |x| x["_id"] }
  end

  def elasticsearch
    @es ||= Elasticsearch::Client.new hosts: [ ENV['ELASTICSEARCH_URL'] ]
  end
end
