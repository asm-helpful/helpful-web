module MostRecentMessageHelper
  def most_recent_message_class(conversation)
    most_recent_message_at = conversation.most_recent_message.updated_at

    case Time.now - most_recent_message_at
    when 0...3.hours      then 'recent'
    when 3.hours...3.days then 'normal'
    else                       'stale'
    end
  end
end
