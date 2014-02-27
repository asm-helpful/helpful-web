require 'spec_helper'

describe AccountSerializer do

  let(:account) { create(:account) }
  subject { described_class.new(account) }

  it_behaves_like "a serializer"

  it "#type is account" do
    expect(subject.type).to eq('account')
  end

end
