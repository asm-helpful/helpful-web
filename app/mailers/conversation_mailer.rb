class ConversationMailer < ActionMailer::Base
  helper :avatar, :nickname
  # Triggered for the first message in a conversation
  def new_conversation(conversation_id, recipient_id)
    @conversation = Conversation.find(conversation_id)
    @recipient = Person.find(recipient_id)

    to = Mail::Address.new @recipient.email
    to.display_name = @recipient.name

    from = Mail::Address.new @conversation.account.mailbox
    from.display_name = @conversation.account.name

    reply_to = Mail::Address.new @conversation.account.mailbox(@conversation.to_param)
    reply_to.display_name = @conversation.account.name

    subject = ConversationSummarizer.new(@conversation).summary
    mail to: to,
         from: from,
         reply_to: reply_to,
         subject: "[#{@conversation.account.slug}] #{subject}"
  end

  # Triggered for each subsequent message in a conversation
  def new_reply(conversation_id, recipient_id)
    @conversation = Conversation.find(conversation_id)
    @recipient = Person.find(recipient_id)

    to = Mail::Address.new @recipient.email
    to.display_name = @recipient.name

    from = Mail::Address.new @conversation.account.mailbox
    from.display_name = @conversation.account.name

    reply_to = Mail::Address.new @conversation.account.mailbox(@conversation.to_param)
    reply_to.display_name = @conversation.account.name

    subject = ConversationSummarizer.new(@conversation).summary
    mail to: to,
         from: from,
         reply_to: reply_to,
         subject: "[#{@conversation.account.slug}] #{subject}"
  end
end
