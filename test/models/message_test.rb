require 'test_helper'

describe Message do
  before do
    @message = Message.new
  end

  it "must be valid" do
    @message.valid?.must_equal true
  end
end