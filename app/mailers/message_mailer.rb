class MessageMailer < ActionMailer::Base
  include SummaryHelper
  helper :avatar, :nickname, :markdown

  layout 'email'

  # Public: Triggered on Message create
  #
  # Returns nothing.
  def created(message_id, recipient_id)
    @message = Message.find(message_id)
    @recipient = Person.find(recipient_id)

    @conversation = @message.conversation
    @previous_messages = @conversation.messages - [@message]

    subject = summary(@conversation)

    mail to: @recipient.email,
         from: @message.account.mailbox,
         reply_to: @conversation.mailbox,
         subject: "[#{@message.account.slug}] #{subject}"
  end
end
