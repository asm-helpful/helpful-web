class ConversationSerializer < BaseSerializer
  attributes :number, :subject, :tags
  has_many :messages

  def include_messages?
	!options[:disable_messages]
  end
end
