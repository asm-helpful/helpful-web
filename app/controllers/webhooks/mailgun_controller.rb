require 'openssl'

class Webhooks::MailgunController < WebhooksController
  before_filter :verify_webhook

  rescue_from ActionController::ParameterMissing, with: :stop_webhook
  rescue_from ActiveRecord::Rollback, with: :retry_webhook

  EMAIL_REGEXP = Regexp.new(
                   /^(?<account_slug>(\w|-)+)(\+(?<conversation_number>\d+))?$/
                 ).freeze

  def create
    require_mailgun_params!

    from = Mail::Address.new(params.fetch(:from).to_ascii)

    identifiers = parse_identifiers(params.fetch(:recipient).to_ascii)
    
    account_slug = identifiers[:account_slug]
    conversation_number = identifiers[:conversation_number]

    if account_slug.nil?
      stop_webhook
      return
    end

    ActiveRecord::Base.transaction do
      # Finds Account
      # GET /api/accounts/acme-corp
      account = Account.find_by!(slug: account_slug)

      # Create the person
      # curl /api/people?email=<from.address>&account=<account.id>
      #
      # curl /api/people \
      #      -d email=<from.address>
      #      -d name=<from.name>
      #      -d account=<account.id>
      person = account.people.find_or_initialize_by(email: from.address)
      # If there's no name for the person, update, otherwise we don't want to
      # override an explicitly set name.
      person.name ||= from.name
      person.save

      # Find or create Conversation
      conversation = if conversation_number
        account.conversations.including_unpaid.find_by!(number: conversation_number)
      else
        account.conversations.create!(
          subject: params.fetch(:subject)
        )
      end

      # Extract attachments
      attachments = params.fetch('attachment-count', 0).to_i.times.map do |i|
        attachment = "attachment-#{i+1}"
        {file: params.fetch(attachment)}
      end

      message = conversation.messages.create!(
        person:  person,
        content: params.fetch('stripped-text'),
        body:    params['stripped-html'],
        subject: params['subject'],
        webhook: Hash[params.reject {|k,_| k.match(/attachment*/) }],
        attachments_attributes: attachments
      )
    end

    head :accepted
  end

  protected

  # FIXME: In the future we will need to make it so that we don't accept
  # the old style of emails which is slug+3@helpful.io for now
  # this should gracefully work for the old style and the new style

  def parse_identifiers(recipient_address)
    to_email = Mail::Address.new(recipient_address)
    local = to_email.local
    uuid_regex = /^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$/
    
    if local.match(uuid_regex)
      Conversation.including_unpaid.find_by(id: local).to_mailbox_hash
    else
      local.match(EMAIL_REGEXP)
    end
  end

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
    params.require('body-plain')
    params.require('stripped-text')
    params.require('message-headers')
    params.require(:token)
    params.require(:signature)
    params.require(:timestamp)
  end

end
