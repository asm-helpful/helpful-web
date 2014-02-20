require "spec_helper"

describe Webhook do
  it "must be valid" do
    expect(build(:webhook)).to be_valid
  end

  it "fills in its body after create" do
    webhook = FactoryGirl.create(:webhook)
    result = JSON.parse(webhook.body)
    expect(result['id']).to eq(webhook.id)
  end

  describe "dispatch" do
    before do
      @webhook = FactoryGirl.create(:webhook)

      @webhook.account.webhook_secret = 'abc123'
      @webhook.account.webhook_url   = 'http://example.com'

      @webhook.body = %{{"id":"634d1cad-94e9-471c-b6dc-95ce18140b89","account_id":"f7dfb266-f88c-4219-9cc6-d4f0e9881de9","created_at":"2013-11-19T16:55:12Z","event":"helpful.test.test","data":{"foo":"bar"}}}
      @expected_signature = '5d2fe8ded5c7bfc33822d9a4d7148629e73ad7a1f8bcb4cd0e34da1b914e0654'

      stub_request(:post, "example.com")
    end

    it "calculates a valid signature" do
      @webhook.signature.must_equal @expected_signature
    end

    it "sends an HTTP request" do
      @webhook.dispatch!

      assert_requested(:post, "http://example.com") do |req|
        {
          body: @webhook.body,
          headers: {'X-Helpful-Webhook-Signature' => @expected_signature}
        }
      end
    end
  end
end
