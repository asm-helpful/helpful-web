class Tag
  attr_accessor :content, :conversation_id

  def initialize(params = {})
    self.content = params.fetch(:content)
    self.conversation_id = params.fetch(:conversation_id)
  end

  def save
    return unless conversation
    conversation.update(tags: unique_tags)
  end

  def conversation
    Conversation.find_by(id: conversation_id)
  end

  def unique_tags
    (conversation.tags + [tag]).uniq
  end

  def tag
    content.sub(/\A#/, '')
  end
end
