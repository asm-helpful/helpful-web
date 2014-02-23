require 'spec_helper'
require 'openssl'

describe Webhooks::MailgunController do

  def account
    @account ||= create(:account)
  end

  def post_webhook(args = {})
    post(:create, default_body.merge(args))
  end

  def find_message_from_response
    message_id = JSON.parse(response.body)['id']
    Message.find(message_id)
  end

  # Construct the default request body including a signature
  def default_body
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

  # The Mailgun API only uses timestamp and token as the inputs to HMAC.
  def generate_signature
    api_key   = "key-bb8ef21a0c161b2f9b0950fee7a52ab1"
    timestamp = Time.now.utc.to_i
    token     = "3fb7496d2e8761c4ca99e2b8265df4df61ba886dc27224a9b2"

    signature = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new('sha256'),
      api_key,
      '%s%s' % [timestamp, token]
    )

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
        assert_difference(->{ Message.count }, 1) do
          post_webhook
        end
      end

      it "returns :accepted" do
        post_webhook
        assert_response :accepted
      end

      it "persists the correct content" do
        content = "This is a test email.\n Thanks."
        post_webhook(
          'stripped-text' => content,
          'body-plain' => 'Other Text'
        )
        message = find_message_from_response

        assert_equal content, message.content
      end

      it "associates the message with the correct person" do
        email = "test-person@example.com"
        person = FactoryGirl.build(:person, email: email)
        post_webhook(from: person.email)
        message = find_message_from_response
        assert_equal person.email, message.person.email
      end

      it "associates the message with the correct account" do
        account = create(:account)
        post_webhook(recipient: "#{account.slug}@helpful.io")
        message = find_message_from_response
        assert_equal account, message.account
      end

      it "associates the message with the correct conversation" do
        conversation = create(:conversation)
        post_webhook(recipient: conversation.mailbox.to_s)
        message = find_message_from_response
        assert_equal conversation, message.conversation
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
