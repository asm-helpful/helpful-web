require 'test_helper'

describe WebhookSerializer do

  before do
    @webhook = Webhook.new(
      id: 'fooid',
      account_id: 'foo account_id',
      event: 'foo event',
      body:  'foo body',
      response_code: 'foo response_code',
      response_body: 'foo response_body',
      response_at:   Time.zone.parse('2014-02-03 04:05:06'),
      created_at: Time.zone.parse('2012-02-03 04:05:06'),
      updated_at: Time.zone.parse('2013-02-03 04:05:06')
    )
    @webhook = flexmock(@webhook, signature: 'foo signature')

    @expected = {
      id: "fooid",
      account_id: "foo account_id",
      event: "foo event",
      body: "foo body",
      signature: "foo signature",
      response: {
          code: "foo response_code",
          body: "foo response_body",
          received: "2014-02-03T04:05:06Z"
      },
      created: "2012-02-03T04:05:06Z",
      updated: "2013-02-03T04:05:06Z",
      _links: { self: { href: "/webhooks/fooid" } }
    }.to_json

    @serializer = WebhookSerializer.new(@webhook)
  end

  it 'has generates the json we expect' do
    @serializer.to_json.must_equal @expected
  end

end
