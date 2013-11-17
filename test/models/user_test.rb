require "test_helper"

class UserTest < ActiveSupport::TestCase

  def test_valid
    assert build(:user).valid?
  end

end
