class MessageMailer < ActionMailer::Base
  include SummaryHelper
  include NicknameHelper

  # Public: Triggered on Message create
  #
  # Returns nothing.
  def created(message_id, recipient_id)
    @message = Message.find(message_id)
    @recipient = Person.find(recipient_id)

    @conversation = @message.conversation
    @account = @conversation.account

    subject = summary(@conversation)

    to = Mail::Address.new(@recipient.email)
    to.display_name = @recipient.name

    from = Mail::Address.new(
      "notifications@#{Helpful.incoming_email_domain}"
    )
    from.display_name = nickname(@message.person)

    reply_to = @conversation.mailbox.dup

    headers(
      'List-ID' => "#{@account.slug}##{@conversation.number} <#{@conversation.number}.#{@account.slug}.helpful.io",
      'List-Archive' => account_conversation_url(@account, @conversation),
      'List-Post' => "<mailto:#{reply_to}>"
      # TODO List Unsubscribe
    )

    mail to: to,
         # FIXME: CC recipient instead
         from: from,
         reply_to: reply_to,
         subject: subject
  end
end
