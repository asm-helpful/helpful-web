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

    from = @message.account.mailbox
    reply_to = @conversation.mailbox
    # Override the default display name with the name of the person who sent
    # the message.
    from.display_name = @message.person.name
    reply_to.display_name = @message.person.name

    mail to: @recipient.email,
         from: from,
         reply_to: reply_to,
         subject: "[#{@message.account.slug}] #{subject}"
  end
end
