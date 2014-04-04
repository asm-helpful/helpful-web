require 'spec_helper'

describe AvatarHelper do

  before do
    @person = OpenStruct.new(email: 'test@example.com')
  end

  it "#gravatar_url" do
    assert_equal 'https://secure.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.png?s=60&d=404', gravatar_url(@person.email, 60)
  end

  it "#avatar returns an element with the avatar class" do
    html = avatar(@person, 60)
    assert_match %r{avatar}, html
  end

  it "#avatar returns an img element" do
    html = avatar(@person, 60)
    assert_match %r{img}, html
  end

  it "#avatar returns an img element with the size" do
    html = avatar(@person, 60)
    assert_match %r{width="60"}, html
  end

  it "#avatar_default returns an element with the avatar-default class" do
    html = avatar_default(@person)
    assert_match /avatar-default/, html
  end

end
