require 'test_helper'

class MessageTest < ActiveSupport::TestCase

  def test_valid
    assert build(:message).valid?
  end

end
