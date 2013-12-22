require "test_helper"

describe Person do
  before do
    @person = Person.new
  end

  it "must be valid" do
    @person.valid?.must_equal true
  end

  describe "Person#parse_email" do

    it "handles email addresses without display names" do
      email = "jsmith@example.com"
      @person.email = email
      @person.save

      assert_equal email, @person.email
    end

    it "parses out the email address from email" do
      @person.email = "John Smith <jsmith@example.com>"
      @person.save

      assert_equal "jsmith@example.com", @person.email
    end
  end
end
