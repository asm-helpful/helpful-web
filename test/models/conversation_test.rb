require 'test_helper'

describe Conversation do
  before do
    @conversation = Conversation.new
  end

  it "must be valid" do
    @conversation.valid?.must_equal true
  end
end