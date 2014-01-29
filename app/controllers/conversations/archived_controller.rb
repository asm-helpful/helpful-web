class Conversations::ArchivedController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_account
  before_action :find_account

  def index
    archive = ConversationsArchive.new(@account, params[:q])
    @conversations = archive.conversations
    @conversation = @conversations.first

    # If there was a query (q) passed, use it for the search field value
    if params[:q]
      @query = params[:q]
    end

    if signed_in?
      if archive.search?
        Analytics.track(user_id: current_user.id, event: 'Read Archived Conversations Index')
      else
        Analytics.track(user_id: current_user.id, event: 'Searched For', properties: { query: archive.query })
      end
    end
  end

  def show
    archive = ConversationsArchive.new(@account)
    @conversations = archive.conversations
    @conversation = archive.archived_conversations.find_by!(number: params.fetch(:id))
    ConversationManager.new(@conversation).assign_agent(current_user)
    @conversation_stream = ConversationStream.new(@conversation)
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

  private

  def conversation_params
    params.require(:conversation).permit(:archive, :id)
  end
end
