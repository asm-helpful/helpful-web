# Figures out which conversation an incoming message belongs to. If it can't
# match it to a conversation it creates a new one.
class Concierge

  def initialize(account, params)
    @account = account
    @conversations = account.conversations
    @params = params
  end

  def find_conversation
    @conversations.find_or_create_by(number: @params[:conversation])
  end

end
