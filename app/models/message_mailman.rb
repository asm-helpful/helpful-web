class MessageMailman
  attr_accessor :message, :recipients

  def self.deliver(message, recipients)
    new(message, recipients).deliver
  end

  def initialize(message, recipients)
    self.message = message
    self.recipients = recipients
  end

  def deliver
    recipients_to_notify.each do |recipient|
      deliver_to(recipient)
    end
  end

  def deliver_to(recipient)
    MessageMailer.delay.created(message.id, recipient.id)
  end

  def recipients_to_notify
    recipients.select do |recipient|
      notify?(recipient)
    end
  end

  def notify?(person)
    person.external? ||
      conversation.notify?(person)
  end

  def assignee
    conversation.user
  end

  def conversation
    message.conversation
  end
end
