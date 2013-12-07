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
end
