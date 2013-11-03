class Messages::Email < Message

  store_accessor :data, :to, :subject, :message_id, :in_reply_to

  # Public: Entry point for new emails, creates a new conversation and message.
  #
  #
  # message - a Mail::Message object
  #
  # Returns nothing.
  def self.receive(message)
    conversation = Conversation.create(account_id: Account.first) 
    

    # TODO: Handle HTML email.
    if message.multipart? 
      content = message.text_part.decoded
    else
      content = message.body.decoded
    end

    Messages::Email.create(
      from: message.from[0], 
      content: content, 
      to: message.to[0].to_s, 
      subject: message.subject, 
      conversation: conversation,
      message_id: message.message_id,
      in_reply_to: message.in_reply_to || nil
    )
  end
end
