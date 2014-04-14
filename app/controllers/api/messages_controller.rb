class Api::MessagesController < ApiController

  def index
    @account = Account.find(params.fetch(:account))
    authorize_account_read!(@account)
    @messages = @account.messages
    respond_with(@messages)
  end

  def show
    @message = Message.includes(:attachments).find(params.fetch(:id))
    authorize_account_read!(@message.account)
    respond_with(@message)
  end

  def create
    @conversation = Conversation.find(message_params.fetch(:conversation))
    authorize_account_read!(@conversation.account)

    @message = @conversation.messages.create!(
      person_id: message_params.fetch(:person),
      content:   message_params.fetch(:body),
      body:      message_params[:body_html],
      subject:   message_params[:subject],
      raw:       message_params[:raw],
      attachments_attributes: message_params.fetch(:attachments, [])
    )

    render json: @message, status: :created
  end

  protected

  def authorize_account_read!(account)
    authorize!(AccountReadPolicy.new(account, current_user))
  end

  def message_params
    params.permit(
      :conversation, :person,
      :body, :body_html, :subject, :raw,
      attachments: [:file]
    )
  end

end
