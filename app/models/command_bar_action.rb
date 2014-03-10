class CommandBarAction
  attr_accessor :action, :content, :params

  def initialize(params = {})
    self.content = params.fetch(:content)
    self.params = params
  end

  def save
    action.save
  end

  def assignment
    @assignment ||= Assignment.new(params)
  end

  def canned_response
    @canned_response_message ||= CannedResponseMessage.new(params)
  end

  def tag
    @tag ||= Tag.new(params)
  end

  def message
    @message ||= Message.new(params)
  end

  def conversation
    action.conversation
  end

  def account
    conversation.account
  end

  def action
    public_send(action_type)
  end

  def action_type
    case content[0]
    when '@' then :assignment
    when ':' then :canned_response
    when '#' then :tag
    else :message
    end
  end
end
