class ConversationSerializer < ActiveModel::HalSerializer
  include TimestampedSerializer

  attributes :id
  attributes :number, :subject

  has_many :messages
  has_one :creator

  def creator
    object.messages.first.person
  end

  def include_creator?
    object.messages.any?
  end

end
