class MessageMailer < ActionMailer::Base
  include SummaryHelper
  include MarkdownHelper
  include ConversationHelper

  def forward(message, person)
    if message.reply?
      headers['In-Reply-To'] = message.in_reply_to.message_id
    end

    mail(
      to: person.email_address,
      from: message.from_address,
      subject: message.subject,
      message_id: message.message_id,
    ) do |format|
      format.text { render(plain: message.content) }
      format.html { render(html: message.html_content.html_safe) }
    end
  end
end
