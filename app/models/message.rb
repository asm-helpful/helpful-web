require 'activerecord/uuid'
require 'elasticsearch'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID

  before_create :populate_person
  after_save :update_search_index

  belongs_to :conversation, touch: true
  delegate   :account, to: :conversation
  belongs_to :person

  after_create  :send_webhook, unless: Proc.new { |m| m.conversation.account.web_hook_url.nil? }

  def webhook_data
    { message: {
      id: self.id,
      conversation_id: self.conversation_id,
      content: self.content,
      from: self.from,
      created_at: self.created_at.utc.iso8601,
      updated_at: self.updated_at.utc.iso8601
    }}
  end

  def send_webhook
    Webhook.create(account: self.account, event: 'message.new', data: self.webhook_data)
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

end
