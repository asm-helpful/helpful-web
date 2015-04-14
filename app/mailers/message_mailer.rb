class MessageMailer < ActionMailer::Base
  include SummaryHelper
  include MarkdownHelper
  include ConversationHelper

  def forward(message, person)
    headers['X-Auto-Response-Suppress'] = 'All'

    if message.reply?
      headers['In-Reply-To'] = message.in_reply_to.message_id
    end

    @message = message

    if person.email_address =~ /.*@helpful.io$/
      Rails.logger.warn "dropping email=#{person.email_address}"
      mail.perform_deliveries = false
    end

    mail to: person.email_address,
         from: message.from_address,
         subject: message.conversation.subject,
         message_id: message.message_id
  end
end
