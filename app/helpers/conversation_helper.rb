module ConversationHelper
  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-danger"
    end
  end

  def flash_icon_class(level)
    case level.to_sym
      when :notice then "ss-info"
      when :success then "ss-check"
      when :error then "ss-alert"
      when :alert then "ss-alert"
    end
  end
end
