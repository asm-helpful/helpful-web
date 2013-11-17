require 'test_helper'

class Messages::EmailTest < ActiveSupport::TestCase

  def test_valid
    assert build(:email).valid?
  end

  # These tests are commented out because the're very brittle and the
  # functionality should probably be in another class/controller.

  # describe "self.receive" do
  #   before do
  #     Mail::TestMailer.deliveries.clear
  #     Mail.deliver do
  #       to 'supportly@example.com'
  #       from 'client@example.com'
  #       subject 'testing'
  #       body 'hello'
  #     end
  #     @message = Mail::TestMailer.deliveries.first
  #   end
  #
  #   it "creates an email message" do
  #     refute @message.nil?
  #
  #     # Clear out all email messages before we run this test
  #     Message.where(type: "Messages::Email").each { |m| m.delete }
  #     assert_equal 0, Message.where(type: "Messages::Email").count
  #
  #     # Now process the email we have created
  #     Messages::Email.receive(@message)
  #     assert_equal 1, Message.where(type: "Messages::Email").count
  #     @email = Message.where(type: "Messages::Email").first
  #
  #     assert_equal 'supportly@example.com', @email.to
  #     assert_equal 'client@example.com', @email.from
  #     assert_equal 'testing', @email.subject
  #     assert_equal 'hello', @email.content
  #     assert_equal @message.message_id, @email.message_id
  #   end
  # end

end
