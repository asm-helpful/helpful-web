require 'test_helper'

describe WebhookWorker do
  before do
    @worker = WebhookWorker.new
  end

  it "posts a webhook" do
    account = FactoryGirl.create(:account, web_hook_url: "http://example.com")
    stub_request(:post, "example.com")
    @worker.perform(account.id, "test.test", {})
    assert_requested(:post, "http://example.com") { |req| req.body.length > 0}
  end
end
