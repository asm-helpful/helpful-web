require 'spec_helper'

describe Nicknamer do

  it "picks the email as a nickname if no other information exists" do
    person = OpenStruct.new(email: 'email@example.com')
    nicknamer = Nicknamer.new(person)
    assert_equal('email@example.com', nicknamer.nickname)
  end

end
