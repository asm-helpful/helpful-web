require 'test_helper'

class NicknameHelperTest < ActionView::TestCase

  test "picks the best nickname for a person" do
    flexmock(Nicknamer).new_instances do |mock|
      mock.should_receive(:nickname)
    end
    nickname(Object.new)
  end

end
