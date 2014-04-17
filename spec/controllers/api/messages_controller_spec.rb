require 'spec_helper'

describe Api::MessagesController do

  describe "POST #create" do

    def post_create(args = {})
      post :create, {
          conversation_id: conversation.id,
          person: person.id,
          subject: 'Help wanted',
          body: 'Please!',
          format: :json
        }.merge(args)
    end

    let(:user) { create(:user) }
    let(:account) { create(:account).tap {|a| a.add_owner(user) } }
    let(:person)  { create(:person, account: account) }
    let(:conversation) { create(:conversation, account: account) }

    # Messages

    it "is successful" do
      sign_in(user)
      post_create
      expect(response).to be_success
    end

    it "persists a new message" do
      sign_in(user)
      expect {
        post_create
      }.to change { Message.count }.by(1)
    end

    it "persists attachments" do
      sign_in(user)
      file = Rack::Test::UploadedFile.new(
        Rails.root.join('LICENSE'),
        'text/plain'
      )
      expect {
        post_create(attachments: [{file: file}])
      }.to change { Attachment.count }.by(1)
    end

  end
end
