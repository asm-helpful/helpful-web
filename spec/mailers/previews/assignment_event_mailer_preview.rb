class AssignmentEventMailerPreview < ActionMailer::Preview
  def created
    assignment_event = AssignmentEvent.last
    AssignmentEventMailer.created(assignment_event.id)
  end
end
