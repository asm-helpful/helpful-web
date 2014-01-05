class MessageMailerPreview < MailView

  def created
    message = Message.first
    recipient = Person.first
    MessageMailer.created(message.id, recipient.id)
  end

end
