require 'spec_helper'

describe ConversationSerializer do

  let(:conversation) { create(:conversation) }
  subject { described_class.new(conversation) }

  it "builds" do
    expect {
      subject.to_json
    }.to_not raise_error
  end

end
