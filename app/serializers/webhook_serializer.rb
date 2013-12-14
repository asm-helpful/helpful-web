class WebhookSerializer < ActiveModel::HalSerializer
  attributes :id
  attributes :account_id, :event, :body, :signature
  attributes :response
  include TimestampedSerializer

  link :self do |webhook|
    { href: "/webhooks/#{webhook.id}" }
  end

  def response
    {
      code: object.response_code,
      body: object.response_body,
      received:   object.response_at.try(:iso8601)
    }
  end
end
