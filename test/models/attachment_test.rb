require "test_helper"

describe Attachment do
  before do
    message = create(:message)
    @attachment = build(:attachment, message: message)
  end

  it "must be valid" do
    @attachment.valid?.must_equal true
  end
end
