class ConversationsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_account!
  after_filter :flash_notice, only: :update

  def archived
    archive = ConversationsArchive.new(@account, params[:q])
    @conversations = archive.conversations
    @conversation = @conversations.first

    Analytics.track(user_id: current_user.id, event: 'Read Archived Conversations Index')
  end

  def inbox
    Analytics.track(user_id: current_user.id, event: 'Read Conversations Index')
  end

  def search
    search = ConversationsInbox.new(@account, params[:q])
    @conversations = search.conversations
    @conversation = @conversations.first

    # If there was a query (q) passed, use it for the search field value
    if params[:q]
      @query = params[:q]
    end

    Analytics.track(user_id: current_user.id, event: 'Searched For', properties: { query: archive.query })
  end

  def show
    find_conversation!
    @messages = @conversation.messages
    @next_conversation = ConversationsInbox.new(@account, current_user).next_after(@conversation)
  end

  def update
    find_conversation!
    ConversationManager.manage(@conversation, current_user, conversation_params)
    redirect_to inbox_account_conversations_path(@account)
  end

  def list
    inbox = ConversationsInbox.new(@account, current_user, params[:q])
    @conversations = inbox.conversations
    render partial: "list"
  end

  private

  def find_conversation!
    @conversation = @account.conversations.find_by!(number: params.fetch(:id))
  end

  def find_account!
    @account = Account.friendly.find_by!(slug: params.fetch(:account_id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end

  def conversation_params
    params.require(:conversation).permit(:archive, :unarchive, :respond_later, :id)
  end

  def flash_notice
    return unless @conversation

    if @conversation.just_archived?
      flash[:notice] = "The conversation has been archived."
    elsif @conversation.just_unarchived?
      flash[:notice] = "The conversation has been moved to the inbox."
    end
  end 

end
