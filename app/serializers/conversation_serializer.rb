class ConversationSerializer < BaseSerializer
  attributes :number, :subject
  has_many :messages
end
