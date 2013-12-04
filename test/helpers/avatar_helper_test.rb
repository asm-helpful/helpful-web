require 'test_helper'

class AvatarHelperTest < ActionView::TestCase

  before do
    @person = OpenStruct.new(email: 'test@example.com')
  end

  test "generates a gavatar url for a user" do
    assert_equal 'https://secure.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.png?s=60', gravatar_url(@person.email, 60)
  end

  test "generates markup for an avatar" do
    output = avatar(@person, 60)
    assert_match %r{class="avatar"}, output
    assert_match %r{img}, output
  end

end
