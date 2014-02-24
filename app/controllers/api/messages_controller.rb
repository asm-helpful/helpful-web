class Api::MessagesController < ApiController
  doorkeeper_for :all, except: [ :create ]

  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    @message = Message.includes(:attachments).find(params.fetch(:id))
    render :json => @message, include: :attachments
  end

  def create
    # HACK: This validates the oauth token if it is passed in.
    methods = Doorkeeper.configuration.access_token_methods
    @token ||= Doorkeeper::OAuth::Token.authenticate request, *methods

    account = Account.find_by(slug: params.fetch(:account))
    email = Mail::Address.new params.fetch(:email)
    author = MessageAuthor.new(account, email)

    conversation = Concierge.new(account, params).find_conversation
    @message = author.compose_message(conversation, params.fetch(:content))

    if @message.save

      if !params[:attachment].nil?
        # TODO: Should handle error here if attachment is not saved? Attachment need a record to be saved so relation can be mapped.
        @message.attachments.create(file: params.fetch(:attachment))
        logger.info "Created attachment"
      end

      render :json => @message,
             :status => :created,
             :callback => params[:callback]
    else
      render :json => @message.errors,
             :status => :unprocessable_entity,
             :callback => params[:callback]
    end
  end

end
