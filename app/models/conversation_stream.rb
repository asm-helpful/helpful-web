class ConversationStream
  include Enumerable

  attr_accessor :conversation

  def initialize(conversation)
    self.conversation = conversation
  end

  def each(&block)
    stream_items.each(&block)
  end

  def stream_items
    [messages, assignment_events, tag_events].flatten.sort_by(&:updated_at)
  end

  def messages
    conversation.messages
  end

  def assignment_events
    conversation.assignment_events
  end

  def tag_events
    conversation.tag_events
  end

  def first_item
    stream_items.first
  end

  def subsequent_items
    stream_items[1..-1]
  end
end
