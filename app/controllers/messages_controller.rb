class MessagesController < ApplicationController

  def index
    @messages = Message.all
  end

  def create
    #TODO: make this an ajax request
    #TODO: optionally archive conversation

    if not current_user
        return redirect_to '/users/sign_in', alert: "Need to be logged in to reply"
    end

    message_params = params['message'].permit(:content, :conversation_id)
    message_params['person_id'] = current_user.id

    @new_message = Message.new message_params

    #Set the conversation as archived
    @conversation = Conversation.find(message_params['conversation_id'])
    @conversation.status = "archived"

    if @new_message.valid? && @new_message.save
        @conversation.save
        redirect_to '/helpful', alert: "Response Added"
    else
        redirect_to '/helpful', alert: "Problem"
    end
  end
end
