require 'test_helper'

describe Message do
  before do
    @message = Message.new
  end

  it "is valid" do
    assert @message.valid?
  end
end
