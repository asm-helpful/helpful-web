class DeviseMailer < Devise::Mailer   
  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
    attachments.inline['logo.png'] = File.read(Rails.root.join('app', 'assets', 'images', 'logo.png'))

    super
  end
end
