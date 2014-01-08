class Api::AttachmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  doorkeeper_for :all, except: [ :create ]
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  respond_to :json

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

  protected

    def parameter_missing(exception)
      render :json => {:error => exception.message},
             :status => :bad_request,
             :callback => params[:callback]
    end

end