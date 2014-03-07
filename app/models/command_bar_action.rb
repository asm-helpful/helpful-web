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
    message
  end

  def tag
    message
  end

  def message
    @message ||= Message.new(params)
  end

  def conversation
    action.conversation
  end

  def action
    public_send(classify_content)
  end

  def classify_content
    case content[0]
    when '@' then :assignment
    when ':' then :canned_response
    when '#' then :tag
    else :message
    end
  end
end
