# Assigns an agent to a conversation if one has not already been assigned
class ConversationManager
  attr_accessor :conversation

  def initialize(conversation)
    self.conversation = conversation
  end

  def assign_agent(agent)
    conversation.update(agent: agent) unless agent_assigned?
  end

  def agent_assigned?
    conversation.agent.present?
  end
end
