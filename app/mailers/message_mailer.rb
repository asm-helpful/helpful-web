class MessageMailer < ActionMailer::Base
  include SummaryHelper
  include MarkdownHelper
  include ConversationHelper

  def forward(message, person)
    if message.reply?
      headers['In-Reply-To'] = message.in_reply_to.message_id
    end

    @message = message

    mail to: person.email_address,
         from: message.from_address,
         subject: message.conversation.subject,
         message_id: message.message_id
  end
end
