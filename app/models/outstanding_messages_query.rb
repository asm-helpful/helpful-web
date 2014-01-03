class OutstandingMessagesQuery
  def self.call(conversation)
    new(conversation).outstanding_customer_messages
  end

  attr_reader :conversation

  def initialize(conversation)
    @conversation = conversation
  end

  def outstanding_customer_messages
    outstanding_messages.select { |m| customer_message?(m) }
  end

  def outstanding_messages
    messages.where(agent_responded_at: nil)
  end

  def messages
    conversation.messages
  end

  def customer_message?(message)
    message.person.account_customer?(account)
  end

  def account
    conversation.account
  end
end
