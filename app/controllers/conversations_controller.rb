class ConversationsController < ApplicationController
  before_action :find_account!, except: [:index]
  before_action :authenticate_user!

  respond_to :html, :json

  def index
    account = Account.find_by(slug: params[:account_id])
    respond_with ConversationMailbox.find(account, current_user, params)
  end

  def archived
    counts = @account.conversations.with_messages.group(:archived).count
  end

  def inbox
    counts = @account.conversations.with_messages.group(:archived).count
  end

  def search
    @results = ConversationSearch.search(@account, current_user, params.slice(:q, :tag, :assignee))
    @conversations = @results[:conversations]

    # If there was a query (q) passed, use it for the search field value
    if params[:q]
      @query = params[:q]
    end

    @assignee = User.find(params[:assignee]) if params[:assignee]

    Analytics.track(user_id: current_user.id, event: 'Searched For', properties: { query: params[:q] })

    respond_with @conversations, location: inbox_account_conversations_path(@account)
  end

  def show
    find_conversation!
    @stream = ConversationStream.new(@conversation)
    @inbox = ConversationsInbox.new(@account, current_user)
    @next_conversation = @inbox.next_conversation(@conversation)
    @previous_conversation = @inbox.previous_conversation(@conversation)

    ReadReceipt.transaction do
      @conversation.messages.each do |m|
        ReadReceipt.find_or_create_by(person: current_user.person, message: m)
      end
    end

    respond_with @conversation
  end

  def update
    find_conversation!
    ConversationManager.manage(@conversation, current_user, conversation_params)

    respond_with @conversation do |format|
      format.html { redirect_to inbox_account_conversations_path(@account) }
    end
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
    params.require(:conversation).permit(:archive, :unarchive, :id, :user_id)
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
