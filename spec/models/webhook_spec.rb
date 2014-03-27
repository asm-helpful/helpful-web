require "spec_helper"

describe Webhook, vcr: true do
  it "must be valid" do
    expect(build(:webhook)).to be_valid
  end

  it "fills in its body after create" do
    webhook = FactoryGirl.create(:webhook)
    result = JSON.parse(webhook.body)
    expect(result['id']).to eq(webhook.id)
  end

  describe "dispatch" do
    let!(:account) { create(:account, webhook_secret: 'abc123', webhook_url: 'http://example.com') }
    let!(:webhook) { create(:webhook, account: account) }

    before do
      webhook.update(body: %{{"id":"634d1cad-94e9-471c-b6dc-95ce18140b89","account_id":"f7dfb266-f88c-4219-9cc6-d4f0e9881de9","created_at":"2013-11-19T16:55:12Z","event":"helpful.test.test","data":{"foo":"bar"}}})
    end

    it "calculates a valid signature" do
      expect(webhook.signature).to eq('5d2fe8ded5c7bfc33822d9a4d7148629e73ad7a1f8bcb4cd0e34da1b914e0654')
    end

    it "sends an HTTP request" do
      expect(HTTParty).to receive(:post).with('http://example.com', webhook.request_options).and_call_original

      webhook.dispatch!

      expect(webhook.response_code).to eq(200)
    end
  end
end
