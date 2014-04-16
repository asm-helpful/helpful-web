class Api::MessagesController < ApiController

  def index
    find_conversation!
    respond_with(@conversation.messages)
  end

  def show
    @message = Message.includes(:attachments).find(params.fetch(:id))
    authorize_account_read!(@message.account)
    respond_with(@message)
  end

  def create
    find_conversation!

    @message = @conversation.messages.create!(
      person_id: message_params.fetch(:person),
      content:   message_params.fetch(:body),
      body:      message_params[:body_html],
      subject:   message_params[:subject],
      raw:       message_params[:raw],
      attachments_attributes: message_params.fetch(:attachments, [])
    )

    respond_with(@message, location: api_message_path(@message))
  end

  protected

  def find_conversation!
    @conversation = Conversation.find(params.fetch(:conversation_id))
    authorize_account_read!(@conversation.account)
  end

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
