require "spec_helper"

describe Attachment do
  before do
    message = create(:message)
    @attachment = build(:attachment, message: message)
  end

  it "must be valid" do
    expect(@attachment).to be_valid
  end
end
