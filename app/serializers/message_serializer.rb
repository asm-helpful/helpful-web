class MessageSerializer < BaseSerializer
  attributes :message_id, :body, :body_html, :content, :conversation_id
  attributes :in_reply_to_id
  attributes :subject

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
