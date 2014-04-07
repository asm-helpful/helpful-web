class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]
  
  def create
    find_account!

    action = CommandBarAction.new(message_params)

    if action.save
      Analytics.track(
        user_id: current_user.id,
        event: 'New Message',
        properties: { action: params['commit'] }
      )

      if params['commit'] == "Archive"
        action.conversation.archive!
        flash[:notice] = "The conversation has been archived and the message sent."
        redirect_to inbox_account_conversations_path(@account)
      else
        redirect_to account_conversation_path(@account, action.conversation)
      end

    else
      if params['commit'] == "Archive" && message_params['content'].empty?
        action.conversation.archive!
        redirect_to inbox_account_conversations_path(@account)
      else
        Analytics.track(user_id: current_user.id, event: 'Message Save Problem')
        redirect_to account_conversation_path(@account, action.conversation), alert: "Problem"
      end
    end
  end

  private

  def find_account!
    @account = Account.find_by_slug!(params.fetch(:account_id))
  end

  def message_params
    params.require(:message).permit(
      :content, :conversation_id
    ).merge(
      person_id: current_user.person.id
    )
  end
end
