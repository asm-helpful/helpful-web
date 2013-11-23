class WebhookSerializer < ActiveModel::Serializer
  attributes :id
  attributes :account_id, :event, :body, :signature
  attributes :response
  include TimestampedSerializer

  def response
    {
      code: object.response_code,
      body: object.response_body,
      received:   object.response_at.try(:iso8601)
    }
  end
end
