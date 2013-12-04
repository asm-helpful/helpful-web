# Takes a conversation and consistently summarizes it to at maximum LENGTH.
# Consistently is important because it shouldn't change after the first message
# so the labels in the UI are consistent.
class ConversationSummarizer

  LENGTH = 140

  def initialize(conversation)
    @conversation = conversation
  end

  def summary
    @conversation.messages.first.content[0...LENGTH]
  end

end
