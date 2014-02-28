require 'spec_helper'

describe AttachmentSerializer do

  let(:attachment) { create(:attachment) }
  subject { described_class.new(attachment) }

  it_behaves_like "a serializer"

  it "#type is attachment" do
    expect(subject.type).to eq('attachment')
  end

end
