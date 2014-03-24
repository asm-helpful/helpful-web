module MostRecentMessageHelper
  def most_recent_message_class(conversation)
    most_recent_message = conversation.most_recent_message
    most_recent_message_at = most_recent_message && most_recent_message.updated_at
    last_activity_at = most_recent_message_at || conversation.updated_at

    case Time.now - last_activity_at
    when 0...3.hours      then 'recent'
    when 3.hours...3.days then 'normal'
    else                       'stale'
    end
  end
end
