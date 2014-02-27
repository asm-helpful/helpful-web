require 'spec_helper'

describe Message do

  let(:message) { build(:message) }

  it "is valid" do
    expect(message).to be_valid
  end

  it "returns a hash of webhook_data" do
    message.save
    webhook_data = message.webhook_data
    webhook_data.each do |k,v|
      assert v.class.in?([Hash, Array, String, Integer, NilClass, Fixnum]),
        "Value is an invalid type: #{k} - #{v.class}"
    end
  end

end
