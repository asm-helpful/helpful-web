require 'spec_helper'

describe WebhookSerializer do

  let(:webhook) { create(:webhook) }
  subject { described_class.new(webhook) }

  it_behaves_like "a serializer"

  it "#type is webhook" do
    expect(subject.type).to eq('webhook')
  end

end
