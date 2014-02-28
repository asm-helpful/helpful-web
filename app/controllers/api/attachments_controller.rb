class Api::AttachmentsController < ApiController
  doorkeeper_for :all, except: [ :create ]

  def index
    message = Message.includes(:attachments).find(params[:message_id])
    render :json => message.attachments.to_json
  end

  def show
    message = Message.includes(:attachments).find(params[:message_id])
    render :json => message.attachments.find(params[:id])
  end

  def create
    # HACK: This validates the oauth token if it is passed in.
    methods = Doorkeeper.configuration.access_token_methods
    @token ||= Doorkeeper::OAuth::Token.authenticate request, *methods

    message = Message.find(params[:message_id])

    @attachment = message.attachments.build(file: params.fetch(:attachment))

    if @attachment.save

      render :json => @attachment,
             :status => :created,
             :callback => params[:callback]

    else
      render :json => @attachment.errors,
             :status => :unprocessable_entity,
             :callback => params[:callback]
    end

  end

end