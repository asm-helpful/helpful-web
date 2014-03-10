class CannedResponseMessage
  attr_accessor :content, :conversation_id, :params

  def initialize(params = {})
    self.content = params.fetch(:content)
    self.conversation_id = params.fetch(:conversation_id)
    self.params = params
  end

  def save
    return unless canned_response
    Message.new(params.merge(content: response)).save
  end

  def response
    canned_response && canned_response.message
  end

  def canned_response
    account && account.canned_responses.find_by(key: key)
  end

  def account
    conversation && conversation.account
  end

  def conversation
    Conversation.find_by(id: conversation_id)
  end

  def key
    content.sub(/\A:/, '')
  end
end
