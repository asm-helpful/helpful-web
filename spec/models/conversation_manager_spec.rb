require "spec_helper"
include ActiveSupport::Testing::Assertions

describe ConversationManager do
  describe "#assign_agent" do
    it "assigns an agent to the conversation if one does not already exist" do
      agent = double("Agent")
      conversation = double("Conversation", update: true)

      manager = ConversationManager.new(conversation)
      allow(manager).to receive(:conversation_assigned?).and_return(false)
      expect(conversation).to receive(:update).with(agent: agent)
      manager.assign_agent(agent)
    end

    it "does not assign an agent if one is already present" do
      agent = double("Agent")
      conversation = double("Conversation", update: true)

      manager = ConversationManager.new(conversation)
      allow(manager).to receive(:conversation_assigned?).and_return(true)
      expect(conversation).to_not receive(:update).with(agent: agent)

      manager.assign_agent(agent)
    end
  end

  describe "#conversation_assigned?" do
    it "returns true if an agent has been assigned to the conversation" do
      conversation = double("Conversation", assigned?: true)
      manager = ConversationManager.new(conversation)
      assert manager.conversation_assigned?
    end

    it "returns false if an agent has not been assigned to the conversation" do
      conversation = double("Conversation", assigned?: false)

      manager = ConversationManager.new(conversation)

      refute manager.conversation_assigned?
    end
  end
end
