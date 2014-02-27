class MessageMailerPreview < ActionMailer::Preview

  def created
    message = Message.last
    recipient = Person.first
    MessageMailer.created(message.id, recipient.id)
  end

end
