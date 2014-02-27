require 'spec_helper'

describe AccountReadPolicy do

  let(:account) { double('Account') }
  let(:user) { double('User') }

  subject { described_class.new(account, user) }

  it "grants users access" do
    allow(account).to receive(:users).and_return(
      double('Users', include?: true)
    )
    expect(subject).to be_access
  end

  it "rejects non-users access" do
    allow(account).to receive(:users).and_return(
      double('Users', include?: false)
    )
    expect(subject).to_not be_access
  end

end
