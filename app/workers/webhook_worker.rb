require 'securerandom'
require 'httparty'

class WebhookWorker
  include Sidekiq::Worker

  def perform(account_id, event, data)

    account = Account.find(account_id)
    options = {
      body: {
        id: SecureRandom.uuid,
        account_id: account.id,
        created: Time.now.utc.to_i,
        event: "helpful." + event.strip,
        data: data
      }
    }

    response = HTTParty.post(account.web_hook_url, options)
    if response.code != 200
      logger.warn %{
        [Webhook Worker] Webhook Failed to Post for Account #{account.id}
      }
    end
  end
end
