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

    create_assignment_event
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

  def lookup_action(params)
    if params[:archive]
      :archive!
    elsif params[:unarchive]
      :unarchive!
    end
  end

  def create_assignment_event
    return unless conversation.previous_changes[:user_id]

    AssignmentEvent.create(
      conversation: conversation,
      user: user,
      assignee: assignee
    )
  end

  def assignee
    conversation.user
  end
end
