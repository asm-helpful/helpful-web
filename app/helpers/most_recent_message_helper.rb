module MostRecentMessageHelper
  def most_recent_message_class(conversation)
    case Time.now - conversation.last_activity_at
    when 0...3.hours      then 'recent'
    when 3.hours...3.days then 'normal'
    else                       'stale'
    end
  end
end
