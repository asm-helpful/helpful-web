class Api::MessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :fetch_message, :except => [:index, :create]
  respond_to :json

  def fetch_message
    @message = Message.find_by_id(params[:id])
  end

  def index
    @messages = Message.all
    respond_to do |format|
      format.json { render json: @messages }
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @message }
    end
  end

  def create

    @account = Account.where(slug: params.fetch(:account)).first

    @message = Messages::Web.new

    # If the client passed a conversation_id use the conversation, otherwise
    # create a new conversation on the specified account
    if conversation_id = params.fetch(:conversation_id, false)
      @message.conversation = Conversation.find(conversation_id)
    else
      @message.conversation_attributes = { account: @account }
    end

    @message.from = params['email']
    @message.content = params['content']
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

end
