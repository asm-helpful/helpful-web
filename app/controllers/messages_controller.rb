class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    find_account!

    message = Message.new(message_params)

    if message.save
      Analytics.track(
        user_id: current_user.id,
        event: 'New Message',
        properties: { action: params['commit'] }
      )

      if @account.prefers_archiving?
        message.conversation.archive!

        redirect_to inbox_account_conversations_path(@account),
          notice: 'The conversation has been archived and the message sent.'
      else
        flash[:preference] = @account.prefers_archiving.nil?

        redirect_to account_conversation_path(@account, message.conversation),
          notice: 'The message has been sent'
      end
    else
      Analytics.track(user_id: current_user.id, event: 'Message Save Problem')

      redirect_to account_conversation_path(@account, message.conversation),
        alert: "Problem"
    end
  end

  private

  def find_account!
    @account = Account.find_by_slug!(params.fetch(:account_id))
  end

  def message_params
    params.require(:message).permit(
      :content, :conversation_id, :attachments_attributes => [:file]
    ).merge(
      person_id: current_user.person.id
    )
  end
end
