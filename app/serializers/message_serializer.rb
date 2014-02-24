class MessageSerializer < ActiveModel::Serializer
  include TimestampedSerializer

  attributes :id
  attributes :body, :body_html

  has_one :conversation, embed: :ids
  has_one :person

  def body
    object.content
  end

  def body_html
    object.body
  end

end
