require 'spec_helper'

describe MessageSerializer do

  let(:message) { create(:message) }
  subject { described_class.new(message) }

  it_behaves_like "a serializer"

  it "#type is message" do
    expect(subject.type).to eq('message')
  end

end
