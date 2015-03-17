class MessageFactory

  attr_reader :message
  attr_reader :account

  def self.build(params)
    new(params).build
  end

  def initialize(params)
    @account = params.delete(:account) || raise(KeyError.new(:account))
    @message = Message.new(params)
  end

  def build
    if @message.reply?
      @message.conversation = @message.in_reply_to.conversation
    else
      @message.create_conversation(
        account: account,
        subject: message.subject
      )
    end
    @message
  end

end
