module ConversationHelper
  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-error"
      when :alert then "alert alert-error"
    end
  end

  def message_body(message)
    if message.data.present?
      message.data["body"]
    else
      markdown(message.content)
    end
  end
end
