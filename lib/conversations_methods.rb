require 'active_support/concern'

module ConversationsMethods
  extend ActiveSupport::Concern

  def preloaded_conversations
    account_conversations.includes(:messages)
  end

  def account_conversations
    account.conversations
  end
end
