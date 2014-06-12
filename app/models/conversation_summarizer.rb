# Takes a conversation and consistently summarizes it to at maximum LENGTH.
# Consistently is important because it shouldn't change after the first message
# so the labels in the UI are consistent.
class ConversationSummarizer

  LENGTH = 140

  attr_accessor :conversation

  def initialize(conversation)
    self.conversation = conversation
  end

  def summary
    self.conversation.subject || tweet_sized_snippet_from_first_message
  end

  def tweet_sized_snippet_from_first_message
    first_message && first_message.content[0...LENGTH]
  end

  def first_message
    conversation.first_message
  end

end
