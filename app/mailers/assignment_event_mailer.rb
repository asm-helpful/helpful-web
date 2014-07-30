class AssignementEventMailer < ActionMailer::Base
  def created(assignment_event_id)
    assignment_event = AssignmentEvent.find(assignment_event_id)
    @conversation = assignment_event.conversation
    @assigner = assignment_event.user
    @assignee = assignment_event.assignee

    to = @assignee.email

    from = Mail::Address.new("notifications@#{Helpful.incoming_email_domain}")
    from.display_name = "Helpful"

    subject = "#{@assigner.name} assigned you to a conversation"

    mail to: to, from: from, subject: subject
  end
end
