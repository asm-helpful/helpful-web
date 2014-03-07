class CommandBarAction
  attr_accessor :action, :content, :params

  def initialize(content, params = {})
    self.content = content
    self.params = params
  end

  # TODO: Call `action.save` once other action types are implemented.
  def save
    message.save && message
  end

  def assignment
  end

  def canned_response
  end

  def tag
  end

  def message
    Message.new(params.merge(content: content))
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
