class AssigneesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account!
  before_action :find_conversation!

  respond_to :json

  def index
    respond_with @conversation.account.users
  end

  def create
    @conversation.user_id = params[:assignee_id]
    @conversation.save

    @assignment_event = AssignmentEvent.create(
      conversation: @conversation,
      user: current_user,
      assignee_id: params[:assignee_id]
    )

    respond_with @assignment_event, location: account_conversation_path(@account, @conversation)
  end

  private

  def find_conversation!
    @conversation = @account.conversations.find_by!(number: params.fetch(:conversation_id))
  end

  def find_account!
    @account = Account.find_by!(slug: params.fetch(:account_id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end
end
