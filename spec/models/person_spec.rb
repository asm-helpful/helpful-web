require "spec_helper"

describe Person do
  before do
    @person = Person.new
  end

  it "must be valid" do
    expect(@person).to be_valid
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

    it "parses out the email address from email even with extended characters" do
      @person.email = "Nícolas Iensen <nicolas@example.com>"
      @person.save

      assert_equal "nicolas@example.com", @person.email
    end
  end

  describe "role helpers for account membership" do
    before do
      @user = FactoryGirl.create(:user)
      @person = FactoryGirl.create(:person, user: @user)
      @account = FactoryGirl.create(:account)
      @membership = FactoryGirl.create(:membership, account: @account)
    end

    it "returns true if the membership has the matching role for the given account" do
      @membership.update(role: 'owner')
      assert @membership.owner?

      @membership.update(role: 'agent')
      assert @membership.agent?
    end
  end

  describe "account memebership" do
    before do
      @user = FactoryGirl.create(:user)
      @person = FactoryGirl.create(:person, user: @user)
      @account = FactoryGirl.create(:account)
      @membership = FactoryGirl.create(:membership, account: @account, user: @user)
    end

    it "returns true if the person is a member of the given account" do
      assert @person.member?(@account)
    end
  end
end
