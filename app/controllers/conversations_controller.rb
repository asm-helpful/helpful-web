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
    @next_conversation = ConversationsInbox.new(@account).next_after(@conversation)
    @conversation_stream = ConversationStream.new(@conversation)
  end

  def update
    find_conversation!
    ConversationManager.manage(@conversation, conversation_params)
    redirect_to inbox_account_conversations_path(@account)
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
    if @conversation.flash_notice.present?
      flash[:notice] = @conversation.flash_notice
    end
  end 

end
