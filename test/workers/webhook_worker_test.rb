require 'test_helper'

describe WebhookWorker do
  before do
    @worker = WebhookWorker.new
  end

  it "posts a webhook" do
    webhook = MiniTest::Mock.new
    webhook.expect :dispatch!, true

    Webhook.stub(:find, webhook) do
      @worker.perform(1)
    end
  end
end
