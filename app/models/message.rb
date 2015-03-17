require 'activerecord/uuid'
require 'elasticsearch/model'
require 'mail/elements/address'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID
  include Elasticsearch::Model

  has_many :attachments,
    inverse_of: :message

  belongs_to :conversation,
    touch: true

  belongs_to :person

  belongs_to :in_reply_to,
    class_name: 'Message'

  delegate :account,
    to: :conversation

  has_many :read_receipts

  store_accessor :data, :recipient, :headers, :raw, :body, :subject

  validates :person_id,
    presence: true

  validates :conversation_id,
    presence: true

  validates :message_id,
    presence: true

  validates :content,
    presence: true

  after_commit :send_webhook,
    on: [:create]

  after_commit :trigger_pusher_new_message,
    on: [:create]

  after_commit :enqueue_to_update_search_index,
    on: [:create, :update]

  after_commit :deliver,
    on: :create

  after_commit :track_analytics,
    on: :create

  scope :most_recent, -> { order('updated_at DESC') }

  accepts_nested_attributes_for :attachments

  before_validation :generate_message_id

  mapping do
    indexes :content
  end

  def reply?
    in_reply_to.present?
  end

  def from_address
    from = self.account.address.dup
    from.display_name = self.person.name
    from
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
    return unless conversation.account.webhook_url?
    # If the changed flag is set we know this is an update
    action = self.changed? ? 'updated' : 'created'
    Webhook.create(account: self.account, event: "message.#{action}", data: self.webhook_data)
  end

  def enqueue_to_update_search_index
    ElasticsearchMessageIndexWorker.perform_async(self.id)
  end

  def deliver
    MessageMailman.deliver(self, recipients)
  end

  def recipients
    ((account.participants + conversation.participants_with_assignee) - [person]).compact
  end

  def trigger_pusher_new_message
    # TODO: Perhaps we should mock Pusher call
    return unless Rails.env.production?

    begin
      Pusher[self.account.slug].trigger('new_message', {})
    rescue Pusher::Error => e
      logger.error e.message
    end
  end

  def track_analytics
    Analytics.track(
      user_id: person.user.id,
      event: 'Message sent',
      timestamp: created_at
    ) if person.agent?
  end

  private

  def generate_message_id
    self.message_id ||= "<#{SecureRandom.uuid}@helpful.mail>"
  end

end
