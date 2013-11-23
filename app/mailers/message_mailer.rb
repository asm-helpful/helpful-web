class MessageMailer < ActionMailer::Base
  default from: "from@example.com"

  def support_message(recipients, message)
    @message = message
    mail(to: recipients, from: message.person.email, subject: 'Helpful Message')
  end
end
