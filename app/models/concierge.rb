# Figures out which conversation an incoming message belongs to. If it can't
# match it to a conversation it creates a new one.
class Concierge
  def initialize(account, params)
    @account = account
    @conversations = account.conversations
    @params = params
  end

  # Public: Finds or creates a conversation based on the params hash. The order
  # of precedence is:
  #   - An explicit conversation number (params[:conversation]).
  #   - A Conversation#mailbox email address (params[:recipient]).
  # If no conversation has been found, create a new one.
  #
  # Returns a Conversation.
  def find_conversation
    # If we have an explicit conversation number try that first
    conversation = @conversations.where(number: @params.fetch(:conversation, nil)).first

    # If that didn't work, match on the recipient email address, looking for replies
    conversation ||= Conversation.match_mailbox(@params.fetch(:recipient, nil))

    # If that didn't work, create a new conversation
    conversation ||= @conversations.create
  end
end
