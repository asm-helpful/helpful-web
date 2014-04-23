class AssignmentEvent < ActiveRecord::Base
  belongs_to :conversation

  belongs_to :user

  belongs_to :assignee,
    class_name: 'User'
end
