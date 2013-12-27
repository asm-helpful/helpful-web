class MessageComposer
  attr_reader :person, :conversation

  def initialize(person, conversation)
    @person = person
    @conversation = conversation
  end

  def compose(content)
    message = Message.create(
      person: person,
      conversation: conversation,
      content: content
    )

    if message.valid? && authored_by_agent?
      timestamp_outstanding_messages(conversation, message.created_at)
    end

    message
  end

  def timestamp_outstanding_messages(conversation, agent_responded_at)
    messages = OutstandingMessagesQuery.call(conversation)
    messages.each { |m| m.update(agent_responded_at: agent_responded_at) }
  end

  def authored_by_agent?
    person.account_agent?(account)
  end

  def account
    conversation.account
  end
end
