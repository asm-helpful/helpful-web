class MessagesController < ApplicationController

  def index
    @messages = Message.all
    
    if current_user
        Analytics.track(user_id: current_user.id, event: 'Listed Messages')
    end
  end

  def create
    #TODO: make this an ajax request
    if not current_user
        return redirect_to '/users/sign_in', alert: "Need to be logged in to reply"
    end
    puts params
    message_params = params['message'].permit(:content, :conversation_id)
    message_params['person_id'] = "ebd74d79-1d67-43c7-b4c9-b1da4b523f9b"#current_user.id

    @new_message = Message.new message_params

    if @new_message.valid? && @new_message.save
        if params['commit'] == "Send & Archive"
            #Set the conversation as archived
            @conversation = Conversation.find(message_params['conversation_id'])
            @conversation.archive
        end
        Analytics.track(user_id: current_user.id,
            event: 'Sent New Message', 
            properties: { action: params['commit'] })
        redirect_to '/helpful', alert: "Response Added"
    else
        Analytics.track(user_id: current_user.id, event: 'Had Message Send Problem')
        redirect_to '/helpful', alert: "Problem"
    end
  end
end
