class ConversationSerializer < ActiveModel::HalSerializer
  include TimestampedSerializer

  attributes :id, :number, :status, :agent, :messages
end
