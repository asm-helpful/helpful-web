require 'activerecord/uuid'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :conversation, touch: true
  belongs_to :person

  after_create :send_webhook, unless: Proc.new { |m| m.conversation.account.web_hook_url.nil? }

  def webhook_data
    {
      id: self.id,
      conversation_id: self.conversation_id,
      content: self.content,
      from: self.from,
      created_at: self.created_at.utc.to_i,
      updated_at: self.updated_at.utc.to_i
    }
  end

  def send_webhook
    WebhookWorker.perform_async(
      self.conversation.account.id,
      "message.new",
      self.webhook_data
    )
  end
end
