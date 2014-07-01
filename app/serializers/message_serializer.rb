class MessageSerializer < BaseSerializer
  attributes :body, :body_html, :content, :conversation_id

  has_one :person

  has_many :attachments

  def body
    object.content
  end

  def body_html
    object.body
  end

  def include_attachments?
    object.attachments.any?
  end

end
