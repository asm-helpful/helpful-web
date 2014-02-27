class WebhookSerializer < BaseSerializer
  attributes :account_id, :event, :body, :signature
  attributes :response

  def response
    {
      code: object.response_code,
      body: object.response_body,
      received: object.response_at.try(:iso8601)
    }
  end
end
