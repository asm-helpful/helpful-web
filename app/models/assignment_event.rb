class AssignmentEvent < ActiveRecord::Base
  belongs_to :conversation

  belongs_to :user

  belongs_to :assignee,
    class_name: 'User'

  after_commit :notify_assignee,
    on: :create

  def notify_assignee
    AssignmentEventMailer.delay.created(id)
  end
end
