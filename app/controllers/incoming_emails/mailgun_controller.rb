require 'openssl'

class IncomingEmails::MailgunController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :verify_webhook

  rescue_from 'ActionController::ParameterMissing' do |exception|
    head :not_acceptable
  end

  def create

    mailgun_params
    @account = Account.match_mailbox(params.fetch(:recipient))

    @message = Messages::Email.new(
      headers:    JSON.parse(params.fetch('message-headers').to_s),
      content:    params.fetch('body-plain'),
      from:       params.fetch(:from),
      subject:    params.fetch(:subject),
      recipient:  params.fetch(:recipient),
      conversation_attributes: { account_id: @account.try(:id) }
    )

    if @message.save
      head :accepted
    else
      render status: :not_acceptable, json: @message.errors
    end
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
    digest = OpenSSL::Digest::Digest.new('sha256')
    data = [timestamp, token].join
    signature == OpenSSL::HMAC.hexdigest(digest, api_key, data)
  end

  private

  def mailgun_params
    params.require(:from)
    params.require(:recipient)
    params.require('body-plain')
    params.require('message-headers')
    params.require(:token)
    params.require(:signature)
    params.require(:timestamp)
  end

end
