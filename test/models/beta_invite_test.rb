require 'test_helper'

class BetaInviteTest < ActiveSupport::TestCase

  def test_valid
    assert build(:beta_invite).valid?
  end

end
