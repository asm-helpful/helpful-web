require 'spec_helper'

describe WebhookWorker do
  it "posts a webhook" do
    webhook = double('webhook')
    allow(Webhook).to receive(:find).and_return(webhook)
    expect(webhook).to receive(:dispatch!).and_return(true)
    subject.perform(1)
  end
end
