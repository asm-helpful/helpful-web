class MessageMailer < ActionMailer::Base
  include SummaryHelper
  include NicknameHelper
  include MarkdownHelper
  include ConversationHelper

  # Public: Triggered on Message create
  #
  # Returns nothing.
  def created(message_id, recipient_id)

    @message = Message.find(message_id)
    @recipient = Person.find(recipient_id)
    @message_markdown = markdown(@message.content)
    @message_text = stripdown(@message.content)

    @conversation = @message.conversation
    @account = @conversation.account

    subject = summary(@conversation)

    @signature_markdown = @account.signature ? markdown(@account.signature) : ''
    @signature_text = @account.signature ? stripdown(@account.signature) : ''

    to = Mail::Address.new(@recipient.email)
    to.display_name = @recipient.name

    from = Mail::Address.new("notifications@#{Helpful.incoming_email_domain}")
    from.display_name = nickname(@message.person)

    reply_to = @conversation.mailbox_email.dup

    @message.attachments.each do |attachment|
      attachments[File.basename(attachment.file.path)] = File.read(attachment.file.path)
    end

    mail to: to,
         # FIXME: CC recipient instead
         from: from,
         reply_to: reply_to,
         subject: subject
  end
end
