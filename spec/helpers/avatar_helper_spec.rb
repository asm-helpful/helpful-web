require 'spec_helper'

describe AvatarHelper do

  before do
    @person = OpenStruct.new(email: 'test@example.com')
  end

  it "#gravatar_url" do
    assert_equal 'https://secure.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0.png?s=120&d=404', gravatar_url(@person.email, 60)
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

  describe "#avatar_path" do
    context "when the person have an uploaded avatar" do
      let(:person) { double('person') }
      let(:avatar) { double('avatar') }
      let(:thumb) { "/path/to/my/avatar.png" }

      before do
        allow(person).to receive(:avatar) { avatar }
        allow(avatar).to receive(:thumb) { thumb }
      end

      it "should return the thumb path" do
        expect(avatar_path person, 30).to match thumb
      end
    end
  end

end
