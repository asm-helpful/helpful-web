require "test_helper"
include ActiveSupport::Testing::Assertions

describe MessageAuthor do
  before do
    @account = FactoryGirl.create(:account)
    @conversation = FactoryGirl.build(:conversation, account: @account)
    @email = Mail::Address.new("Philip J. Fry <fry@planetexpress.com>")
    @content = "Hello."
    @person = FactoryGirl.create(
      :person,
      name: "Philip J. Fry",
      email: "fry@planetexpress.com",
      account: @account
    )
  end

  describe "#compose_message" do
    it "creates a new message in the conversation" do
      message_author = MessageAuthor.new(@account, @email)
      message = message_author.compose_message(@conversation, @content)
      assert_equal message.conversation, @conversation
    end

    it "creates a new message with content" do
      message_author = MessageAuthor.new(@account, @email)
      message = message_author.compose_message(@conversation, @content)
      assert_equal message.content, @content
    end

    it "creates a new message with the correct author" do
      message_author = MessageAuthor.new(@account, @email)
      message = message_author.compose_message(@conversation, @content)
      assert_equal message.person, @person
    end
  end

  describe "#person_with_updated_name" do
    it "returns the author after updating their name" do
      message_author = MessageAuthor.new(@account, @email)
      person = message_author.person_with_updated_name
      assert_equal person.name, @email.display_name
    end
  end

  describe "#person" do
    it "finds the author by email address if they exist" do
      message_author = MessageAuthor.new(@account, @email)
      person = message_author.person
      assert_equal person, @person
    end

    it "creates a new author if one cannot be found" do
      @email = Mail::Address.new("Dr. Zoidberg <zoidberg@planetexpress.com>")
      message_author = MessageAuthor.new(@account, @email)
      person = message_author.person
      refute_equal person, @person
      assert person.persisted?
    end
  end
end
