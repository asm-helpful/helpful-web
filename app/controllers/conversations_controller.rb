class ConversationsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_account!
  after_filter :flash_notice, only: :update

  respond_to :html, :json

  def archived
    archive = ConversationsArchive.new(@account, params[:q])
    @conversations = archive.conversations
    @conversation = @conversations.first

    Analytics.track(user_id: current_user.id, event: 'Read Archived Conversations Index')
  end

  def inbox
    Analytics.track(user_id: current_user.id, event: 'Read Conversations Index')
    @assignment_user = User.find_by(id: params[:user_id])
    inbox = ConversationsInbox.new(@account, current_user, params[:q], @assignment_user)
    @conversations = inbox.conversations
    WelcomeConversation.create(@account, current_user) unless @account.conversations.including_unpaid.exists?
    respond_with @conversations
  end

  def search
    search = ConversationsInbox.new(@account, current_user, params[:q])
    @conversations = search.conversations
    @conversation = @conversations.first

    # If there was a query (q) passed, use it for the search field value
    if params[:q]
      @query = params[:q]
    end

    Analytics.track(user_id: current_user.id, event: 'Searched For', properties: { query: search.query })

    respond_with @conversations, location: inbox_account_conversations_path(@account)
  end

  def show
    find_conversation!
    @stream = ConversationStream.new(@conversation)
    @inbox = ConversationsInbox.new(@account, current_user)
    @next_conversation = @inbox.next_conversation(@conversation)
    @previous_conversation = @inbox.previous_conversation(@conversation)
  end

  def update
    find_conversation!
    ConversationManager.manage(@conversation, current_user, conversation_params)

    respond_with @conversation do |format|
      format.html { redirect_to inbox_account_conversations_path(@account) }
    end
  end

  def list
    @assignment_user = User.find_by(id: params[:user_id])
    inbox = ConversationsInbox.new(@account, current_user, params[:q], @assignment_user)
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
    params.require(:conversation).permit(:archive, :unarchive, :respond_later, :id, :user_id)
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
