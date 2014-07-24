# Figures out which conversation an incoming message belongs to. If it can't
# match it to a conversation it creates a new one.
module Concierge
  # Public: Finds or creates a conversation based on the params hash. The order
  # of precedence is:
  #   - An explicit conversation number (params[:conversation]).
  #   - A Conversation#mailbox email address (params[:recipient]).
  # If no conversation has been found, create a new one.
  #
  # Returns a Conversation.
  def self.find_conversation(account, params)
    conversations = account.conversations
    # If we have an explicit conversation number try that first
    conversations.find_by(number: params[:conversation]) ||

    # If that didn't work, match on the recipient email address, looking for replies
    Conversation.match_mailbox(params[:recipient])  ||

    # If that didn't work, create a new conversation
    conversations.create(subject: params[:subject])
  end
end
