require 'activerecord/uuid'
require 'elasticsearch'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID

  before_create :populate_person
  after_save :update_search_index

  attr_accessor :from

  belongs_to :conversation, touch: true
  delegate   :account, to: :conversation

  belongs_to :person
  accepts_nested_attributes_for :conversation
  has_many :read_receipts

  after_create  :send_webhook, unless: Proc.new { |m| m.conversation.account.webhook_url.nil? }

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
    Webhook.create(account: self.account, event: 'message.created', data: self.webhook_data)
  end

  def update_search_index
    # TODO: Support testing search in test environment
    if ENV['ELASTICSEARCH_URL'] && !Rails.env.test?
      es = Elasticsearch::Client.new hosts: [ ENV['ELASTICSEARCH_URL'] ]
      es.index( { index: 'helpful', type:  'message', id: self.id, body: { content: self.content} } )
    end
  end

  def populate_person
    if person_id.blank?
      person = Person.find_or_create_by!(email: from.to_s.strip)
      self.person_id = person.id
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
