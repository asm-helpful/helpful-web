module Helpful
  extend self

  def incoming_email_domain
    ENV['INCOMING_EMAIL_DOMAIN'] || 'helpful.io'
  end

end
