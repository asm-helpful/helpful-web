class MessageMailer < ActionMailer::Base

  def created(message_id, recipient_id)
    @message = Message.find(message_id)
    @recipient = Person.find(recipient_id)

    mail to: @recipient.email,
         from: @message.person.email,
         subject: 'New Helpful Message'
  end

end
