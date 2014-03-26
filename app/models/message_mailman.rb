class MessageMailman
  attr_accessor :message

  def self.deliver(message, recipients)
    new(message).deliver_to_each(recipients)
  end

  def initialize(message)
    self.message = message
  end

  def deliver_to_each(recipients)
    recipients.each do |recipient|
      deliver_to(recipient)
    end
  end

  def deliver_to(recipient)
    MessageMailer.delay.created(message.id, recipient.id)
  end
end
