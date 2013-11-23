require "test_helper"

class MessageMailerTest < ActionMailer::TestCase
  tests MessageMailer

  test "support message" do
    @conversation = FactoryGirl.create(:conversation_with_messages)
    @message = @conversation.messages.first
    @recipients = ['a@a.com', 'b@b.com']
    
    email = MessageMailer.support_message(@recipients, @message).deliver

    assert !ActionMailer::Base.deliveries.empty?
 	@recipients.each { |recipient| assert (email.to.include? recipient) } 
    assert_equal 'Helpful Message', email.subject
  end
end
