require 'activerecord/uuid'
require 'elasticsearch/model'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID
  include Elasticsearch::Model

  has_one :account,
    through: :conversation

  has_many :attachments,
    inverse_of: :message

  belongs_to :conversation,
    touch: true

  belongs_to :person

  has_many :read_receipts

  delegate :account,
    to: :conversation

  store_accessor :data, :recipient, :headers, :raw, :body, :subject

  validates :person_id,
    presence: true

  validates :conversation_id,
    presence: true

  validates :content,
    presence: true

  after_save :send_webhook, if: ->(message) {
    message.conversation.account.webhook_url?
  }

  after_create :trigger_pusher_new_message
  after_commit :enqueue_to_update_search_index, on: [:create, :update]
  after_commit :send_email, on: :create

  scope :most_recent, -> { order('updated_at DESC') }

  accepts_nested_attributes_for :attachments

  mapping do
    indexes :content
  end

  def webhook_data
    { message: {
      id: self.id,
      conversation_id: self.conversation_id,
      content: self.content,
      person: self.person.attributes,
      created_at: self.created_at.utc.iso8601,
      updated_at: self.updated_at.utc.iso8601
    }}
  end

  def send_webhook
    return if conversation.unpaid?
    # If the changed flag is set we know this is an update
    action = self.changed? ? 'updated' : 'created'
    Webhook.create(account: self.account, event: "message.#{action}", data: self.webhook_data)
  end

  def enqueue_to_update_search_index
    ElasticsearchMessageIndexWorker.perform_async(self.id)
  end

  def send_email
    return if conversation.unpaid?
    MessageMailman.deliver(self, mail_recipients)
  end

  def mail_recipients
    conversation.participants - [self.person]
  end

  def trigger_pusher_new_message
    # TODO: Perhaps we should mock Pusher call
    return unless Rails.env.production?
    return if conversation.unpaid?

    begin
      Pusher[self.account.slug].trigger('new_message', {})
    rescue Pusher::Error => e
      logger.error e.message
    end
  end
end
