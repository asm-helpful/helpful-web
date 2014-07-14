class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(user, 'invitation-token')
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(user, 'invitation-token')
  end

  def unlock_instructions
    Devise::Mailer.unlock_instructions(user, 'invitation-token')
  end

  def user
    user = User.create(email: 'chuck@example.com')
    user.create_person(name: 'Chuck Smith', email: 'chuck@example.com')
    user
  end
end
