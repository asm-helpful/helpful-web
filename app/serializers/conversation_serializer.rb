class ConversationSerializer < BaseSerializer
  attributes :number, :subject, :tags
  has_many :messages
end
