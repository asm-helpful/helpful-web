require 'test_helper'

describe Conversation do
  before do
    @conversation = Conversation.new
  end

  it "is valid" do
    assert @conversation.valid?
  end
end
