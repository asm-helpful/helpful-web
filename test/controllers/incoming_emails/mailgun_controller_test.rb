require 'test_helper'
require 'openssl'

describe IncomingEmails::MailgunController do
  def post_webhook(args = {})

    # The mailgun API only uses timestamp and token as the inputs to HMAC
    # as a result we can just generate a static signature to test with.
    #
    # To generate a signature:
    #
    #  signature = OpenSSL::HMAC.hexdigest(
    #                        OpenSSL::Digest::Digest.new('sha256'),
    #                        api_key,
    #                        '%s%s' % [timestamp, token])
    api_key   = "key-bb8ef21a0c161b2f9b0950fee7a52ab1"
    signature = "e34ce2cbae65ced873f2dd3657a4d145fe0245ff3d896b6a27da82b246892df0"
    timestamp = 1385618722
    token     = "3fb7496d2e8761c4ca99e2b8265df4df61ba886dc27224a9b2"

    ENV['MAILGUN_API_KEY'] = api_key

    @account = FactoryGirl.create(:account)
    body = {
      from:       args[:from]       || "test@test.com",
      subject:    args[:subject]    ||  "test email",
      recipient:  args[:recipient]  || "#{@account.slug}@helpful.io",

      'body-plain'      =>  args['body-plain'] || "Test email.\n Thanks",
      'message-headers' =>  args['message-headers'] || [
                              ["From", "test@test.com"],
                              ["Recieved", "by luna.mailgun.net"],
                              ["Recieved", "from mail.google.com by mxa.mailgun.org"]
                            ],

      timestamp:  args[:timestamp]  || timestamp,
      token:      args[:token]      || token,
      signature:  args[:signature]  || signature
    }

    post :create, body
  end

  describe "#verify_hook" do
    it "validates the webhook signature" do
      post_webhook token: 123123123
      assert_response :forbidden
    end
  end

  describe "#create" do
    describe "valid webhook" do
      it "creates a new email message" do
        assert_difference("Messages::Email.count") do
          post_webhook
        end
      end

      it "returns :accepted" do
        post_webhook
        assert_response :accepted
      end

      it "persists the correct content" do
        content = "This is a test email.\n Thanks."
        post_webhook('body-plain' => content)
        assert_equal content, Messages::Email.last.content
      end

      it "associates the message with the correct person" do
        email = "test-person@example.com"
        post_webhook(from: email)
        assert_equal email, Messages::Email.last.person.email
      end

      it "associates the message with the correct person" do
        email = "test-person@example.com"
        person = FactoryGirl.create(:person, email: email)

        post_webhook(from: email)
        assert_equal person, Messages::Email.last.person
      end

      it "associates the message with the correct account" do
        post_webhook
        assert_equal @account, Messages::Email.last.account
      end

      it "associates the message with the correct conversation" do
        conversation = create(:conversation)
        post_webhook(recipient: conversation.mailbox.to_s)
        assert_equal conversation, Messages::Email.last.conversation
      end
    end

    describe "invalid webhook" do
      it "returns :not_acceptable" do
        post :create, { from: "testing@example.com" }
        assert_response :not_acceptable
      end

      it "returns :not_acceptable" do
        post_webhook recipient: "test@test.com"
        assert_response :not_acceptable
      end
    end
  end
end
