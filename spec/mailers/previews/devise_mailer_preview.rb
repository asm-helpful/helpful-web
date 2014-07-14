class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    DeviseMailer.confirmation_instructions(user, 'invitation-token')
  end

  def reset_password_instructions
    DeviseMailer.reset_password_instructions(user, 'invitation-token')
  end

  def unlock_instructions
    DeviseMailer.unlock_instructions(user, 'invitation-token')
  end

  def user
    user = User.create(email: 'chuck@example.com')
    user.create_person(name: 'Chuck Smith', email: 'chuck@example.com')
    user
  end
end
