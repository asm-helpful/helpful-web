class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  respond_to :html, :json

  def create
    find_account!

    message = Message.new(message_params)

    if message.save
      Analytics.track(
        user_id: current_user.id,
        event: 'New Message',
        properties: { action: params['commit'] }
      )

      message.conversation.archive! if archive_conversation?

      respond_with message, location: account_conversation_path(@account, message.conversation) do |format|
        format.html do
          flash[:preference] = @account.prefers_archiving.nil?

          if message.conversation.archived?
            redirect_to inbox_account_conversations_path(@account),
              notice: 'The conversation has been archived and the message sent.'
          else
            redirect_to account_conversation_path(@account, message.conversation),
              notice: 'The message has been sent'
          end
        end

        format.json
      end
    else
      Analytics.track(user_id: current_user.id, event: 'Message Save Problem')

      respond_with message do |format|
        format.html do
          redirect_to account_conversation_path(@account, message.conversation),
            alert: "Problem"
        end

        format.json
      end
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

  def archive_conversation?
    params[:archive_conversation].to_s == 'true'
  end
end
