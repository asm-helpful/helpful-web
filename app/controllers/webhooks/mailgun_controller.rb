require 'openssl'

class Webhooks::MailgunController < WebhooksController
  before_filter :verify_webhook

  rescue_from ActionController::ParameterMissing, with: :stop_webhook
  rescue_from ActiveRecord::Rollback, with: :retry_webhook

  def create
    require_mailgun_params!

    ActiveRecord::Base.transaction do
      # Finds Account
      recipient = Mail::Address.new(params.fetch(:recipient).to_ascii)
      account = if recipient.domain == 'helpful.io'
        Account.find_by!(slug: recipient.local)
      else
        Account.find_by!(forwarding_address: recipient.address)
      end

      # Upsert sender
      from = Mail::Address.new(params['Reply-To'] || params.fetch(:from).to_ascii)
      person = account.people.find_or_initialize_by(email: from.address)
      person.update(name: from.name)

      # Find previous message
      in_reply_to = Message.find_by(message_id: params['In-Reply-To'])

      message = MessageFactory.build(
        account: account,
        message_id: params.fetch('Message-Id'),
        in_reply_to: in_reply_to,
        person:  person,
        content: params.fetch('stripped-text'),
        body:    params['stripped-html'],
        subject: params['subject'],
        webhook: Hash[params.reject {|k,_| k.match(/attachment*/) }],
        attachments_attributes: params.fetch('attachment-count', 0).to_i.times.map do |i|
          {file: params.fetch("attachment-#{i+1}")}
        end
      )

      message.save!

      if Rails.env.production?
        Customerio.client.track(inbox.owner.id, 'received_message')
      end
    end

    head :accepted
  end

  protected

  def verify_webhook
    signature_status = valid_signature?(
      ENV['MAILGUN_API_KEY'],
      params.fetch(:token),
      params.fetch(:timestamp),
      params.fetch(:signature)
    )

    if not signature_status
      render nothing: true, status: 403
    end
  end

  def valid_signature?(api_key, token, timestamp, signature)
    digest = OpenSSL::Digest.new('sha256')
    data = [timestamp, token].join
    signature == OpenSSL::HMAC.hexdigest(digest, api_key, data)
  end

  def retry_webhook
    head :not_acceptable
  end

  def stop_webhook
    head :unprocessable_entity
  end

  private

  def require_mailgun_params!
    params.require(:from)
    params.require(:recipient)
    params.require('Message-Id')
    params.require('body-plain')
    params.require('stripped-text')
    params.require('message-headers')
    params.require(:token)
    params.require(:signature)
    params.require(:timestamp)
  end

end
