module ConversationsHelper

  def preview(conversation, length = 100)
    messages = conversation.messages
    message  = messages.first
    (message && message.content) ? message.content.first(length) : ""
  end

  def distance_in_time_of_last_message(conversation)
    distance_of_time_in_words_to_now(conversation.updated_at)
  end

end
