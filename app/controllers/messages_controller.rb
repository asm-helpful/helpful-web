class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    find_account!

    @message = CommandBarAction.new(message_params)

    if @message.save
      Analytics.track(
        user_id: current_user.id,
        event: 'New Message',
        properties: { action: params['commit'] }
      )

      if params['commit'] == "Send & Archive"
        @message.conversation.archive!
        redirect_to inbox_account_conversations_path(@account)
      else
        redirect_to account_conversation_path(@account, @message.conversation)
      end


    else
      Analytics.track(user_id: current_user.id, event: 'Message Save Problem')
      redirect_to conversation_path(current_account, @message.conversation), alert: "Problem"
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
