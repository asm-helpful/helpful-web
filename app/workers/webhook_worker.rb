require 'securerandom'
require 'httparty'

class WebhookWorker
  include Sidekiq::Worker

  def perform(webhook_id)
    webhook = Webhook.find(webhook_id)

    webhook.dispatch!
  end
end
