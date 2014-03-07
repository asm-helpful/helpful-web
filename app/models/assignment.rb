class Assignment
  attr_accessor :content, :conversation_id

  def initialize(params = {})
    self.content = params.fetch(:content)
    self.conversation_id = params.fetch(:conversation_id)
  end

  def save
    return unless conversation && user
    conversation.update(user: user)
  end

  def conversation
    Conversation.find_by(id: conversation_id)
  end

  def user
    User.joins(:person).where(people: { name: name }).first
  end

  def name
    content.sub(/\A@/, '')
  end
end
