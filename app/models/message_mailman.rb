class MessageMailman
  attr_accessor :message
  attr_accessor :recipients

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

  # private

  def recipients_to_notify
    recipients.uniq.select do |person|
      notify?(person )
    end
  end

  def notify?(person)
    person.notify?
  end

  def deliver_to(recipient)
    MessageMailer.forward(message, recipient).deliver_later
  end

end
