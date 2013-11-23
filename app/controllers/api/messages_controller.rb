class Api::MessagesController < ApplicationController
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
    #TODO: currently there's a database constraint that every message needs a conversation_id, remove first below
    @message = Message.new
    @message.conversation_id = params.fetch(:conversation_id, Conversation.first.id)
    @message.from = params['email']
    @message.content = params['content']
    respond_to do |format|
      if @message.save
        format.json { render json: @message, status: :created, callback: params.fetch(:callback, nil)}
      else
        format.json { render json: @message.error, status: :unprocessable_entity, callback: params.fetch(:callback, nil)}
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