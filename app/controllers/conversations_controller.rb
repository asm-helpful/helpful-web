class ConversationsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_account!

  def archived
    archive = ConversationsArchive.new(@account, params[:q])
    @conversations = archive.conversations
    @conversation = @conversations.first

    Analytics.track(user_id: current_user.id, event: 'Read Archived Conversations Index')
  end

  def inbox
    inbox = ConversationsInbox.new(@account, params[:q])
    @conversations = inbox.conversations
    @conversation = @conversations.first
    Analytics.track(user_id: current_user.id, event: 'Read Conversations Index')
  end

  def search
    archive = ConversationsArchive.new(@account, params[:q])
    @conversations = archive.conversations
    @conversation = @conversations.first

    # If there was a query (q) passed, use it for the search field value
    if params[:q]
      @query = params[:q]
    end

    Analytics.track(user_id: current_user.id, event: 'Searched For', properties: { query: archive.query })
  end

  def show
    find_conversation!
    ConversationManager.new(@conversation).assign_agent(current_user)
    @conversation_stream = ConversationStream.new(@conversation)
  end

  def update
    find_conversation!
    @conversation.update_attributes(conversation_params)
    redirect_to account_conversation_path(@account, @conversation)
  end

  private

  def find_conversation!
    @conversation = @account.conversations.find_by!(number: params.fetch(:id))
  end

  def find_account!
    @account = Account.friendly.find(params.fetch(:account_id))
  end

  def conversation_params
    params.require(:conversation).permit(:archive, :id)
  end

end
