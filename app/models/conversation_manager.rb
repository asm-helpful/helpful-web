class ConversationManager
  attr_accessor :conversation

  def self.manage(conversation, params)
    new(conversation).manage(params)
  end

  def initialize(conversation)
    self.conversation = conversation
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
    conversation.try(action)
  end

  def update_conversation(params)
    conversation.update(params)
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
