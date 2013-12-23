require 'test_helper'
require 'openssl'

describe Webhooks::MailgunController do

  def post_webhook(args = {})
    post :create, default_body.merge(args)
  end


  # Construct the default request body including a signature
  def default_body
    account = FactoryGirl.create(:account)

    {
      from:             "test@test.com",
      subject:          "test email",
      recipient:        "#{account.slug}@helpful.io",

      'body-plain'      =>  "Test email.\n Thanks",
      'stripped-text'   =>  "Test email.\n Thanks",
      'message-headers' =>  [
        ["From", "test@test.com"],
        ["Recieved", "by luna.mailgun.net"],
        ["Recieved", "from mail.google.com by mxa.mailgun.org"]
      ],
    }.merge(generate_signature)
  end

  def generate_signature
    # The mailgun API only uses timestamp and token as the inputs to HMAC.

    api_key   = "key-bb8ef21a0c161b2f9b0950fee7a52ab1"
    timestamp = Time.now.utc.to_i
    token     = "3fb7496d2e8761c4ca99e2b8265df4df61ba886dc27224a9b2"

    signature = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest::Digest.new('sha256'),
      api_key,
      '%s%s' % [timestamp, token])

    ENV['MAILGUN_API_KEY'] = api_key

    {
      timestamp:        timestamp,
      token:            token,
      signature:        signature
    }
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
        post_webhook('stripped-text' => content, 'body-plain' => 'Other Text')
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
        account = create(:account)
        post_webhook(recipient: "#{account.slug}@helpful.io")
        assert_equal account, Messages::Email.last.account
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
