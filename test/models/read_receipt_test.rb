require "test_helper"

describe ReadReceipt do
  before do
    @person = FactoryGirl.create(:person)
    @message = FactoryGirl.create(:message)
    @rr = FactoryGirl.build(:read_receipt, person: @person, message: @message)
  end

  it "should create a read receipt" do
    @rr.save
    assert @rr.valid?
  end

  it "should return the associated person" do
    @rr.save
    assert_equal @person, @rr.person
  end

  it "should return the associated message" do
    @rr.save
    assert_equal @message, @rr.message
  end
end
