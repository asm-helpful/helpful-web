require 'spec_helper'

describe ConversationSerializer do

  let(:conversation) { create(:conversation) }
  subject { described_class.new(conversation) }

  it_behaves_like "a serializer"

  it "#type is conversation" do
    expect(subject.type).to eq('conversation')
  end

end
