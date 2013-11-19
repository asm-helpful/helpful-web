class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def index
    @messages = Message.all

    if current_user
      Analytics.track(user_id: current_user.id, event: 'Listed Messages')
    end
  end

  def create
    @message = Message.new message_params

    if @message.save
      if params['commit'] == "Send & Archive"
        #Set the conversation as archived
        @conversation = Conversation.find(message_params['conversation_id'])
        @conversation.archive
      end
      Analytics.track(user_id: current_user.id,
          event: 'Sent New Message',
          properties: { action: params['commit'] })
      redirect_to conversations_path(current_account), alert: "Response Added"
    else
      Analytics.track(user_id: current_user.id, event: 'Had Message Send Problem')
      redirect_to conversations_path(current_account), alert: "Problem"
    end
  end

  def message_params
    params.require(:message).permit(:content, :conversation_id).merge(person_id: current_user.person.id)
  end
end
