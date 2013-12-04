require 'test_helper'

describe Messages::Email do

  before do
    @email = build(:email)
  end

  it "is valid" do
    assert_operator @email, :valid?
  end

end
