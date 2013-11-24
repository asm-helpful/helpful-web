class Messages::Email < Message

  store_accessor :data, :to, :subject, :message_id, :in_reply_to

  # Public: Entry point for new emails, creates a new conversation and message.
  #
  #
  # message - a Mail::Message object
  #
  # Returns nothing.
  def self.receive(message)
    # TODO: Rework this.
  end

  def webhook_data
    super.merge({
      to: self.to,
      subject: self.subject,
      message_id: self.message_id
    })
  end
  
end
