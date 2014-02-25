require 'spec_helper'

describe PersonSerializer do

  let(:person) { create(:person) }
  subject { described_class.new(person) }

  it_behaves_like "a serializer"

  it "#type is person" do
    expect(subject.type).to eq('person')
  end

end
