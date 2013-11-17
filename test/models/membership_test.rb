require "test_helper"

class MembershipTest < ActiveSupport::TestCase

  def test_valid
    assert build(:membership).valid?
  end

end
