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
      when :notice then "geomicon-info geomicon"
      when :success then "geomicon-check geomicon"
      when :error then "geomicon-alert geomicon"
      when :alert then "geomicon-alert geomicon"
    end
  end
end
