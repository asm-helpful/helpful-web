class ConversationSerializer < BaseSerializer
  attributes :account_slug, :archived, :create_message_path, :last_activity_at, :message_count,
    :number, :path, :subject, :summary, :tags

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

  def path
    "/#{account_slug}/#{number}"
  end

  def create_message_path
    current_account && url_helpers.account_messages_path(current_account)
  end

  def stream_items
    ConversationStream.new(object).stream_items
  end
end
