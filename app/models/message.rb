require 'activerecord/uuid'
require 'elasticsearch'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :person
  belongs_to :conversation, touch: true
  has_one :account, through: :conversation

  has_many :read_receipts
  has_many :attachments, inverse_of: :message

  delegate :account, :to => :conversation

  store_accessor :data, :recipient, :headers, :raw, :body, :subject

  validates :person,       presence: true
  validates :conversation, presence: true
  validates :content,      presence: {
                             allow_nil: false,
                             allow_blank: false
                           }

  after_save :send_webhook, if: ->(message) {
    message.conversation.account.webhook_url?
  }

  after_create :trigger_pusher_new_message
  after_commit :enqueue_to_update_search_index, on: [:create, :update]
  after_commit :send_email, on: :create

  scope :most_recent, -> { order('updated_at DESC') }

  accepts_nested_attributes_for :attachments

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
    # If the changed flag is set we know this is an update
    action = self.changed? ? 'updated' : 'created'
    Webhook.create(account: self.account, event: "message.#{action}", data: self.webhook_data)
  end

  def enqueue_to_update_search_index
    ElasticsearchMessageIndexWorker.perform_async(self.id)
  end

  def elasticsearch_index_data
    {index: 'helpful', type: 'message', id: self.id, body: {content: self.content}}
  end

  # TODO: Support testing search in test environment
  def update_search_index
    if ENV['ELASTICSEARCH_URL'] && !Rails.env.test?
      elasticsearch_client = Elasticsearch::Client.new hosts: [ENV['ELASTICSEARCH_URL']]
      elasticsearch_client.index(elasticsearch_index_data)
    end
  end

  # Public: Trigger MessageMailer.created when a new message is created.
  #
  # Returns nothing.
  def send_email
    mail_recipients.each do |person|
      MessageMailer.delay.created(id, person.id)
    end
  end

  def mail_recipients
    conversation.participants - [self.person]
  end

  def trigger_pusher_new_message
    # TODO: Perhaps we should mock Pusher call
    if !Rails.env.test?
      begin
        Pusher[self.account.slug].trigger('new_message', {})
      rescue Pusher::Error => e
        logger.error e.message
      end
    end
  end
end
