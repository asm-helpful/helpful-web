class Messages::Email < Message

  store_accessor :data, :recipient, :headers, :raw, :body

  # def webhook_data
  #   super.merge({
  #     recipient: self.recipient,
  #     subject: self.subject,
  #     headers: self.headers
  #   })
  # end
end
