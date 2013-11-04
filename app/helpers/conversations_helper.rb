module ConversationsHelper
  def preview(conversation, length = 100)
    messages = conversation.ordered_messages
    message  = messages.first
    (message && message.content) ? message.content.first(length) : ""
  end

  def distance_in_time_of_last_message(conversation)
    conversation.ordered_messages.last ?
      distance_of_time_in_words_to_now(conversation.ordered_messages.last.created_at) :
      "never"
  end
end
