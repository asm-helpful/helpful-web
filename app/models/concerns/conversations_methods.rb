require 'active_support/concern'

module ConversationsMethods
  extend ActiveSupport::Concern

  def preloaded_conversations
    account_conversations.includes(:messages, :participants, :most_recent_message, first_message: :person, subsequent_messages: :person).
      with_messages_count
  end

  def account_conversations
    account.conversations
  end
end
