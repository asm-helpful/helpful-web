require 'test_helper'

describe Conversation do
  before do
    @conversation = Conversation.new
  end

  it "is valid" do
    assert @conversation.valid?
  end

  it "should not be archived by default" do
    assert !@conversation.archived?
  end

  it "should be archived after archive" do
    conversation = FactoryGirl.create :conversation
    conversation.archive
    assert conversation.archived?
  end

  it "should only return unarchived conversations" do
    FactoryGirl.create :conversation
    FactoryGirl.create :archived_conversation
    Conversation.unarchived.each do |c|
      assert !c.archived?
    end
  end

end
