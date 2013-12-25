class Api::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  doorkeeper_for :all, except: [ :create ]
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  respond_to :json

  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    @message = Message.find(params.fetch(:id))
    render json: @message
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

      render :json => @message,
             :status => :created,
             :callback => params[:callback]
    else
      render :json => @message.errors,
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
