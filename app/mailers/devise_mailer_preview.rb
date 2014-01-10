class DeviseMailerPreview < MailView
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(User.new({email: 'chuck@example.com'}), 'invitation-token')
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.new({email: 'chuck@example.com'}), 'invitation-token')
  end

  def unlock_instructions
    Devise::Mailer.unlock_instructions(User.new({email: 'chuck@example.com'}), 'invitation-token')
  end
end
