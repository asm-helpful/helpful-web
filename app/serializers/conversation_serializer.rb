class ConversationSerializer < BaseSerializer
  attributes :number, :subject, :tags
  has_many :messages

  def include_messages?
    options.fetch(:include_messages, true)
  end
end
