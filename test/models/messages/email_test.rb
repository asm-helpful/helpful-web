require 'test_helper'

describe Messages::Email do
  before do
    @email = FactoryGirl.build(:email)
  end

  it "is valid" do
    assert @email.valid?
  end

  describe "self.receive" do

    before do
      Mail.deliver do
        to 'supportly@example.com'
        from 'client@example.com'
        subject 'testing'
        body 'hello'
      end
      @message = Mail::TestMailer.deliveries.first
    end

    it "creates an email message" do
      refute @message.nil?
      Messages::Email.receive(@message)
      assert_equal 1, Message.where(type: "Messages::Email").count
      @email = Message.where(type: "Messages::Email").first
      assert_equal 'supportly@example.com', @email.to
      assert_equal 'client@example.com', @email.from
      assert_equal 'testing', @email.subject
      assert_equal 'hello', @email.content
      assert_equal @message.message_id, @email.message_id
    end
  end
end
