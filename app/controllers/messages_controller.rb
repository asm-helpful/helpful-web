class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]
  after_action :process_promotion, only: [:create]

  respond_to :json

  def create
    message = MessageFactory.build(message_params)

    if message.save
      message.conversation.archive! if archive_conversation?

      respond_with message, location: account_conversation_path(message.account, message.conversation) do |format|
        format.html do
          flash[:preference] = message.account.prefers_archiving.nil?

          if message.conversation.archived?
            redirect_to inbox_account_conversations_path(message.account),
              notice: 'The conversation has been archived and the message sent.'
          else
            redirect_to account_conversation_path(message.account, message.conversation),
              notice: 'The message has been sent'
          end
        end

        format.json
      end

    else
      respond_with message do |format|
        format.html do
          redirect_to account_conversation_path(message.account, message.conversation),
            alert: "Problem"
        end

        format.json
      end
    end
  end

  private

  def find_account!
    @account ||= Account.find_by_slug!(params.require(:account_id))
  end

  def message_params
    params.require(:message).permit(
      :content,
      :in_reply_to_id,
      :attachments_attributes => [:file],
    ).merge(
      person: current_user.person,
      account:   find_account!
    )
  end

  def process_promotion
    if @account.asm_signup_promotion_completed_at.nil?
      AsmSignupPromotionWorker.perform_async(@account.id)
    end
  end

  def archive_conversation?
    params[:archive_conversation].to_s == 'true'
  end
end
