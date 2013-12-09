require 'test_helper'

describe Conversation do
  before do
    @conversation = build(:conversation)
  end

  it "is valid" do
    assert @conversation.valid?
  end

  it "should not be archived by default" do
    assert !@conversation.archived?
  end

  it "should be archived after archive" do
    conversation = create(:conversation)
    conversation.archive
    assert conversation.archived?
  end

  it "should not be archived after un_archive" do
    @conversation.archive
    @conversation.save

    @conversation.un_archive
    refute Conversation.find(@conversation.id).archived?
  end

  it "should only return unarchived conversations" do
    create(:conversation)
    create(:archived_conversation)
    Conversation.open.each do |c|
      assert !c.archived?
    end
  end

  it "supports the archive attribute for setting archive status" do
    @conversation.archive = true
    @conversation.save

    assert Conversation.find(@conversation.id).archived?
  end

  it "supports the archive attribute for setting archive status" do
    @conversation.archive
    @conversation.save

    @conversation.archive = false
    @conversation.save
    refute Conversation.find(@conversation.id).archived?
  end

  it "adds the correct conversation number on create based on account_id" do
    @account = create(:account)

    @conversation_1 = create(:conversation, account: @account)
    assert_equal 1, @conversation_1.number

    @conversation_2 = create(:conversation, account: @account)
    assert_equal 2, @conversation_2.number

    @conversation_3 = create(:conversation)
    assert_equal 1, @conversation_3.number
  end

  describe "#mailbox" do

    it "must return a valid email" do
      @conversation.save
      refute @conversation.mailbox.address.empty?
    end

    it "must have the correct local part" do
      @conversation.save
      expected = [@conversation.account.slug, "+", @conversation.number].join.to_s
      assert_equal expected, @conversation.mailbox.local
    end

    it "must have the correct domain part" do
      @conversation.save
      assert_equal ENV['INCOMING_EMAIL_DOMAIN'], @conversation.mailbox.domain
    end
  end

  describe ".match_mailbox" do

    it "matches a mailbox email to a conversation" do
      @conversation.save
      assert_equal @conversation, Conversation.match_mailbox(@conversation.mailbox.to_s)
    end

    it "raises an exception if a converstion is not found" do
      @conversation.save
      address = @conversation.mailbox.to_s
      @conversation.delete
      assert_raise ActiveRecord::RecordNotFound do
        Conversation.match_mailbox!(address)
      end
    end
  end
end
