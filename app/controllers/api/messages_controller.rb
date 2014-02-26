class Api::MessagesController < ApiController

  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    @message = Message.includes(:attachments).find(params.fetch(:id))
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

    render json: @message, status: :created
  end

  protected

  def find_conversation!
    id = message_params.fetch(:conversation)
    @conversation = Conversation.find(id)
  end

  def find_person!
    @person = @conversation.account.people.find(message_params.fetch(:id))
  end

  def message_params
    params.permit(
      :conversation, :person,
      :body, :body_html, :subject, :raw,
      attachments: [:file]
    )
  end

end
