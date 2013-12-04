class Api::MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :fetch_message, :only => [:show, :update, :destroy]
  respond_to :json

  def index
    @messages = Message.all
    render json: @messages
  end

  def show
    render json: @message
  end

  def create
    account = Account.where(slug: params.fetch(:account)).first

    conversation = Concierge.new(account, params).find_conversation

    @message = conversation.messages.new

    @message.person = account.people.find_or_create_by(email: params.fetch(:email))
    @message.content = params.fetch('content')

    respond_to do |format|
      if @message.save
        format.json { render json: @message, status: :created, callback: params.fetch(:callback, nil)}
      else
        format.json { render json: @message.errors, status: :unprocessable_entity, callback: params.fetch(:callback, nil)}
      end
    end
  end

  def update
    #TODO: implement
    respond_to do |format|
    #if @message.update_attributes(params[:user])
    #  format.json { head :no_content, status: :ok }
    #else
      format.json { render json: "Figure out update permissions", status: :unprocessable_entity }
    end
  end

  def destroy
    #TODO: implement
    respond_to do |format|
    #if @message.destroy
    #  format.json { head :no_content, status: :ok }
    #else
      format.json { render json: "Figure out destroy permissions", status: :unprocessable_entity }
    end
  end

  protected

  def fetch_message
    @message = Message.find(params.fetch(:id))
  end

end
