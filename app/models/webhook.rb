require 'activerecord/uuid'
#require 'digest/sha256'

class Webhook < ActiveRecord::Base
  include ActiveRecord::UUID
  belongs_to :account

  validates :event, presence: true
  validates :account_id, presence: true

  attr_accessor :data

  after_create :fill_in_body
  after_create :enqueue_to_send, on: create

  def dispatch!
    options = {
      body: body,
      headers: {'X-Helpful-Webhook-Signature' => signature}
    }

    response = HTTParty.post(account.webhook_url, options)

    self.update_attributes(
      response_code: response.code,
      response_body: response.body,
      response_at:   Time.zone.now.utc
    )
  end

  def signature
    secret = self.account.webhook_secret
    raise(ArgumentError, "Missing account secret for account #{self.account.id}") if secret.blank?

    OpenSSL::HMAC.hexdigest('sha256', secret, body)
  end

  protected

  def fill_in_body
    b = {
      id: self.id,
      account_id: account_id,
      created_at: self.created_at.utc.iso8601,
      event: "helpful." + event.strip,
      data: data
    }.to_json

    self.update_attribute(:body, b)
  end

  def enqueue_to_send
    WebhookWorker.perform_async(self.id)
  end
end
