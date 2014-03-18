class ConversationManager
  attr_accessor :conversation, :user

  def self.manage(conversation, user, params)
    new(conversation, user).manage(params)
  end

  def initialize(conversation, user)
    self.conversation = conversation
    self.user = user
  end

  def manage(params)
    action = lookup_action(params)

    if action
      take_action(action)
    else
      update_conversation(params)
    end
  end

  def take_action(action)
    public_send(action)
  end

  def update_conversation(params)
    conversation.update(params)
  end

  def archive!
    conversation.archive!
  end

  def unarchive!
    conversation.unarchive!
  end

  def respond_later!
    conversation.respond_later!(user)
  end

  def lookup_action(params)
    if params[:archive]
      :archive!
    elsif params[:unarchive]
      :unarchive!
    elsif params[:respond_later]
      :respond_later!
    end
  end
end
