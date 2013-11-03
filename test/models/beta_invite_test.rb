require 'test_helper'

describe BetaInvite do
  before do
    @beta_invite = BetaInvite.new(
      email: "bob@example.com"
    )
  end

  it "is valid" do
    assert @beta_invite.valid?
  end
end
