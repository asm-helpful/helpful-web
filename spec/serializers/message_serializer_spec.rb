require 'spec_helper'

describe MessageSerializer do

  let(:message) { create(:message) }
  subject { described_class.new(message) }

  it "builds" do
    expect {
      subject.to_json
    }.to_not raise_error
  end

end
