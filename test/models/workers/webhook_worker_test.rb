require 'test_helper'

class WebhookWorkerTest < ActiveSupport::TestCase

  def test_posting_a_webhook
    worker = WebhookWorker.new
    account = create(:account, web_hook_url: "http://example.com")
    stub_request(:post, "example.com")
    worker.perform(account.id, "test.test", {})
    assert_requested(:post, "http://example.com") { |req| req.body.length > 0}
  end

end
