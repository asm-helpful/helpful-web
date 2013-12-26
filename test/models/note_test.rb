require 'test_helper'

describe Note do

  it "is valid" do
    assert build(:note).valid?, 'is not valid'
  end

end
