class Api::MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:create]

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
    account = Account.where(slug: params.fetch(:account)).first
    conversation = Concierge.new(account, params).find_conversation
    person = account.people.find_or_create_by(email: params.fetch(:email))

    @message = conversation.messages.new(
      content: params.fetch(:content),
      person:  person
    )

    if @message.valid? && @message.save

      recipients = @message.conversation.participants - [@message.person]
      recipients.each do |recipient|
        MessageMailer.created(@message.id, recipient.id).deliver
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
