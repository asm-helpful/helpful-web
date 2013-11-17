require 'test_helper'

class PeopleHelperTest < ActionView::TestCase

  def test_gravatar
    person = build_stubbed(:person, email: 'test@example.com')
    assert_equal gravatar(person), "https://secure.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.png?s=60&d=retro"
  end

  def test_avatar
    person = build_stubbed(:person)
    assert_match %r{avatar}, avatar(person)
  end

end
