class WebhookWorker
  include Sidekiq::Worker

  def perform(account, event, object)
  end

end
