# Assigns an agent to a conversation if one has not already been assigned
class ConversationManager
  attr_accessor :conversation

  def initialize(conversation)
    self.conversation = conversation
  end

  def assign_agent(agent)
    conversation.update(agent: agent) unless conversation_assigned?
  end

  def conversation_assigned?
    conversation.assigned?
  end
end
