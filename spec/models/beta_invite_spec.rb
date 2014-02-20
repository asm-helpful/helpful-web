require 'spec_helper'

describe BetaInvite do
  before do
    @beta_invite = BetaInvite.new(
      email: "bob@example.com"
    )
  end

  it "is valid" do
    expect(@beta_invite).to be_valid
  end
end
