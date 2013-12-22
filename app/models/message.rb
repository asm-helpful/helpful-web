require 'activerecord/uuid'
require 'elasticsearch'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :person
  belongs_to :conversation, touch: true

  has_many :read_receipts

  delegate :account, :to => :conversation

  validates :person,       presence: true
  validates :conversation, presence: true
  validates :content,      presence: {
                             allow_nil: false,
                             allow_blank: false
                           }

  after_save :update_search_index
  after_save :send_webhook, if: ->(message) {
    message.conversation.account.webhook_url?
  }
  after_create :send_email

  scope :internal,     -> { where(internal: true) }
  scope :not_internal, -> { where(internal: false) }

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

  # TODO: Support testing search in test environment
  # TODO: Move to an async job
  def update_search_index
    if ENV['ELASTICSEARCH_URL'] && !Rails.env.test?
      es = Elasticsearch::Client.new hosts: [ ENV['ELASTICSEARCH_URL'] ]
      es.index( { index: 'helpful', type:  'message', id: self.id, body: { content: self.content} } )
    end
  end

  # Public: Trigger MessageMailer.created when a new message is created.
  #
  # Returns nothing.
  def send_email
    mail_recipients.each do |person|
      MessageMailer.created(id, person.id).deliver
    end
  end

  def mail_recipients
    if internal?
      # There's an N+1 here because for every person we must retrieve the exact membership that matches the account of this conversation.
      # There shouldn't be more than ~10 participants on a conversation though, so it's probably acceptable for now
      (conversation.participants.includes(:user => :memberships) - [person]).select {|p| p.agent_or_higher?(conversation.account_id) }
    else
      (conversation.participants - [person])
    end
  end

  # Public: Create a read receipt for this message.
  #
  # person -  the Person which the read receipt should be created for
  #           (default: self.person).
  #
  # Returns true if the ReadReceipt was created successfully.
  def mark_read(person = self.person)
    rr = ReadReceipt.create(person: person, message: self)
    return rr.valid?
  end

end
