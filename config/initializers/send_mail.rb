if ENV['USE_GMAIL'] && Rails.env.development?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'example.com',
      user_name:            ENV['SENDER_EMAIL_ADDRESS'],
      password:             ENV['SENDER_EMAIL_PASSWORD'],
      authentication:       'plain',
      enable_starttls_auto: true
  }
end
