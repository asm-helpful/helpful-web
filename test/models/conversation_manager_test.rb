require "test_helper"
include ActiveSupport::Testing::Assertions

describe ConversationManager do
  describe "#assign_agent" do
    it "assigns an agent to the conversation if one does not already exist" do
      agent = flexmock("Agent")
      conversation = flexmock("Conversation", update: true)

      manager = ConversationManager.new(conversation)
      manager = flexmock(manager, conversation_assigned?: false)
      manager.assign_agent(agent)

      assert_spy_called conversation, :update, { agent: agent }
    end

    it "does not assign an agent if one is already present" do
      agent = flexmock("Agent")
      conversation = flexmock("Conversation", update: true)

      manager = ConversationManager.new(conversation)
      manager = flexmock(manager, conversation_assigned?: true)
      manager.assign_agent(agent)

      assert_spy_not_called conversation, :update, { agent: agent }
    end
  end

  describe "#conversation_assigned?" do
    it "returns true if an agent has been assigned to the conversation" do
      conversation = flexmock("Conversation", assigned?: true)

      manager = ConversationManager.new(conversation)

      assert manager.conversation_assigned?
    end

    it "returns false if an agent has not been assigned to the conversation" do
      conversation = flexmock("Conversation", assigned?: false)

      manager = ConversationManager.new(conversation)

      refute manager.conversation_assigned?
    end
  end
end
