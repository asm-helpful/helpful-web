require 'spec_helper'
require 'openssl'

describe Webhooks::MailgunController do

  let(:account) { create(:account) }
  let(:conversation) { create(:conversation, account: account) }
    # The Mailgun API only uses timestamp and token as the inputs to HMAC.
  def mailgun_webhook_signature
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

  def post_create(args = {})
    post :create, mailgun_webhook_signature.merge(
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
      ).merge(args)
  end

  # def find_message_from_response
  #   message_id = JSON.parse(response.body)['id']
  #   Message.find(message_id)
  # end

  # Construct the default request body including a signature
  # def default_body

  # end

  describe "POST #create" do

    context "with an invalid signature" do
      it "is forbidden" do
        post_create token: 123123123
        assert_response :forbidden
      end
    end

    # FIXME: would be nicer to reuse the tests in some way instead of 
    # copying and pasting them and having seperate contexts
    # I tried meta programming but there were some weird issues
    # maybe its a rspec beta issue. For now it works for testing the 
    # seperate email address types
    context "with a valid signature" do
      context "accountslug@helpful.io type email" do
        
        let(:email) { "#{account.slug}@helpful.io" }
        
        it "is accepted" do
          post_create(recipient: email)
          expect(response).to be_success
        end

        it "persists a message" do
          expect {
            post_create(recipient: email)
          }.to change { Message.count }.by(1)
        end

        it 'stores the raw webhook in the message' do
          post_create(recipient: email)
          message = Message.order('created_at DESC').first
          expect(message.webhook).to_not be_blank
        end

        it "persists attachments" do
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('LICENSE'),
            'text/plain'
          )

          expect {
            post_create 'recipient' => email,
                        'attachment-count' => 1,
                        'attachment-1' => file
          }.to change { Attachment.count }.by(1)
        end
      end

      context "abc123sha@helpful.io type email" do
        let(:email) { "#{conversation.id}@helpful.io" }

        it "is accepted" do
          post_create(recipient: email)
          expect(response).to be_success
        end

        it "persists a message" do
          expect {
            post_create(recipient: email)
          }.to change { Message.count }.by(1)
        end

        it "persists attachments" do
          file = Rack::Test::UploadedFile.new(
            Rails.root.join('LICENSE'),
            'text/plain'
          )

          expect {
            post_create 'recipient' => email,
                        'attachment-count' => 1,
                        'attachment-1' => file
          }.to change { Attachment.count }.by(1)
        end
      end

    #   it "associates the message with the correct person" do
    #     email = "test-person@example.com"
    #     person = FactoryGirl.build(:person, email: email)
    #     post_webhook(from: person.email)
    #     message = find_message_from_response
    #     assert_equal person.email, message.person.email
    #   end

    #   it "associates the message with the correct account" do
    #     post_webhook(recipient: "#{account.slug}@helpful.io")
    #     message = find_message_from_response
    #     assert_equal account, message.account
    #   end

    #   it "associates the message with the correct conversation" do
    #     conversation = create(:conversation)
    #     post_webhook(recipient: conversation.mailbox_email.to_s)
    #     message = find_message_from_response
    #     assert_equal conversation, message.conversation
    #   end
    end

    # describe "invalid webhook" do
    #   it "returns :not_acceptable" do
    #     post :create, { from: "testing@example.com" }
    #     assert_response :not_acceptable
    #   end

    #   it "returns :not_acceptable" do
    #     post_webhook recipient: "test@test.com"
    #     assert_response :not_acceptable
    #   end
    # end
  end

  describe "#parse_identifiers" do
    context "abc123sha@helpful.io email format" do
      
      let(:to_address) { conversation.mailbox_email.to_s }

      before do
        @hash = controller.send(:parse_identifiers, to_address)
      end

      it "returns a hash containing the account_slug" do
        expect(@hash[:account_slug]).to eq(account.slug)
      end

      it "returns a hash containing the conversation number" do
        expect(@hash[:conversation_number]).to eq(conversation.number)
      end
    end

    context "accountslug@helpful.io email format" do
      
      let(:to_address) { "#{account.slug}@helpful.io" }

      before do
        @hash = controller.send(:parse_identifiers, to_address)
      end
      
      it "returns a hash containing the account_slug" do
        expect(@hash[:account_slug]).to eq(account.slug)
      end
      
      it "returns a hash that has a nil conversation_number" do
        expect(@hash[:conversation_number]).to be_nil
      end
    end
  end
end
