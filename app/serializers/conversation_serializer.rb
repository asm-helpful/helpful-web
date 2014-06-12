class ConversationSerializer < BaseSerializer
  attributes :number, :subject, :summary, :tags, :account_slug, :url, :message_count, :last_activity_at, :archived
  has_one :creator_person
  has_many :messages
  has_many :participants
  has_many :stream_items

  def include_messages?
    options.fetch(:include_messages, true)
  end

  def message_count
    object.messages.count
  end

  def account_slug
    object.account.slug
  end

  def summary
    ConversationSummarizer.new(object).summary
  end

  def url
    "/#{account_slug}/#{number}"
  end

  def stream_items
    ConversationStream.new(object).stream_items
  end
end
