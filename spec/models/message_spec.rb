require 'spec_helper'

describe Message do
  before do
    @message = FactoryGirl.build(:message)
  end

  it "is valid" do
    assert @message.valid?
  end

  it "returns a hash of webhook_data" do
    @message.save
    webhook_data = @message.webhook_data
    webhook_data.each do |k,v|
      assert v.class.in?([Hash, Array, String, Integer, NilClass, Fixnum]),
        "Value is an invalid type: #{k} - #{v.class}"
    end
  end

  describe "#mark_read" do
    it "creates a read receipt with no person argument" do
      person = FactoryGirl.create(:person)
      @message.person = person
      @message.save

      @message.mark_read
      assert_equal 1, ReadReceipt.where(person: person, message: @message).count
    end
    it "creates a read receipt with a person argument" do
      person = FactoryGirl.create(:person)
      @message.save

      @message.mark_read(person)
      assert_equal 1, ReadReceipt.where(person: person, message: @message).count
    end

    it "creates a read receipt with a person argument" do
      person = FactoryGirl.create(:person)
      @message.save

      @message.mark_read(person)
      refute_equal 1, ReadReceipt.where(person: @message.person, message: @message).count
    end
  end
end
