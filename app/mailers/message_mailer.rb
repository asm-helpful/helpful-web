class MessageMailer < ActionMailer::Base
  helper :avatar, :nickname

  # Public: Triggered on Message create
  #
  # Returns nothing.
  def created(message_id, recipient_id)
    @message = Message.find(message_id)
    @recipient = Person.find(recipient_id)

    @conversation = @message.conversation

    subject = ConversationSummarizer.new(@conversation).summary
    mail to: @recipient.email,
         from: @message.account.mailbox,
         reply_to: @conversation.mailbox,
         subject: "[#{@message.account.slug}] #{subject}"
  end
end
