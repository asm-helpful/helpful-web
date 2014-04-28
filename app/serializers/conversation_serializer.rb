class ConversationSerializer < BaseSerializer
  attributes :number, :subject, :tags, :account_slug, :url
  has_many :messages

  def include_messages?
    options.fetch(:include_messages, true)
  end

  def account_slug
    object.account.slug
  end

  def url
    "/#{account_slug}/#{number}"
  end
end
