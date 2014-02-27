class MessageSerializer < BaseSerializer
  attributes :body, :body_html

  has_one :conversation, embed: :ids
  has_one :person

  has_many :attachments

  def body
    object.content
  end

  def body_html
    object.body
  end

end
