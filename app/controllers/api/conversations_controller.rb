class Api::ConversationsController < ApiController

  def index
    find_account!
    @conversations = @account.conversations
    respond_with(@conversations)
  end

  def create
    find_account!
    @conversation = @account.conversations.create!(conversation_params)
    render json: @conversation, status: :created
  end

  def show
    @conversation = Conversation.find(params.fetch(:id))
    authorize! AccountReadPolicy.new(@conversation.account, current_user)
    respond_with(@conversation)
  end

  protected

  def find_account!
    @account = Account.find_by!(id: params.fetch(:account))
    authorize! AccountReadPolicy.new(@account, current_user)
  end

  def conversation_params
    params.permit(:subject)
  end

end
