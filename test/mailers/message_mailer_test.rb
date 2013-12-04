require 'test_helper'

describe MessageMailer, :created do

  before do
    @message = create(:message)
    @recipient = create(:person)
  end

  it "delivers" do
    email = MessageMailer.created(@message.id, @recipient.id).deliver
    assert_equal true, ActionMailer::Base.deliveries.any?
  end

  it "delivers to recipient" do
    email = MessageMailer.created(@message.id, @recipient.id).deliver
    assert_equal true, email.to.include?(@recipient.email)
  end

  it "delivers with subject" do
    email = MessageMailer.created(@message.id, @recipient.id).deliver
    assert_equal 'New Helpful Message', email.subject
  end

end
