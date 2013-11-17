require "test_helper"

class PersonTest < ActiveSupport::TestCase

  def test_valid
    assert build(:person).valid?
  end

end
