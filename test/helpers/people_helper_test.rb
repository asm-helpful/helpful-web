require 'test_helper'

describe PeopleHelper do
  before do
    @person = FactoryGirl.build(:person)
  end
  
  it "should generate a gavatar url for a user" do
    @person.email = "test@example.com"
    @person.save
    assert_equal gravatar(@person), "https://secure.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.png?s=60&d=retro"
  end

  it "should generate markup for an avatar" do
    @person.save
    output = avatar(@person)
    assert_match %r{div}, output
    assert_match %r{class="avatar"}, output
    assert_match %r{img}, output
    refute_match %r{http:}, output
  end
end
