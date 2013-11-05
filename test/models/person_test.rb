require "test_helper"

describe Person do
  before do
    @person = Person.new
  end

  it "must be valid" do
    @person.valid?.must_equal true
  end
end
