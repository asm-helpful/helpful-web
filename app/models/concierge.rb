# Figures out which conversation an incoming message belongs to. If it can't
# match it to a conversation it creates a new one.
class Concierge
  EMAIL_REGEX = Regexp.new(/\S+(\+\S+)?\+(?<number>\d)/).freeze
  def initialize(account, params)
    @account = account
    @conversations = account.conversations
    @params = params
  end

  def find_conversation
    number = @params[:conversation] || number_from_email(@params[:recipient])
    @conversations.find_or_create_by(number: number)
  end

  private

  # Private: Extract the conversation number from an email adddress.
  #
  # Returns conversation number or nil.
  def number_from_email(input_address)
    email = Mail::Address.new input_address
    EMAIL_REGEX.match(email.address).try { |match| match[:number] }
  end

end
