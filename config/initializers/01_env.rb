if ENV["CONFY_URL"]
    Confy::Config.env(ENV['CONFY_URL'])
end

module Helpful
  extend self

  def incoming_email_domain
    ENV['INCOMING_EMAIL_DOMAIN'] || 'helpful.io'
  end

  def outgoing_email_domain
    ENV['OUTGOING_EMAIL_DOMAIN'] || 'helpful.io'
  end
end
