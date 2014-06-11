class ConversationSerializer < BaseSerializer
  attributes :number, :subject, :summary, :tags, :account_slug, :url, :creator_person
  has_many :messages
  has_many :participants

  def include_messages?
    options.fetch(:include_messages, true)
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
end
