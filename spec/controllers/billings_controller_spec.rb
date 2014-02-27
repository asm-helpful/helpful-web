require "spec_helper"
require 'openssl'

describe BillingsController do
  it "GET show" do
    sign_in_as_admin
    get :show, account_id: @account.slug
    expect(response).to be_success
  end

  describe "POST webhook" do
    before do
      allow(Chargify).to receive(:shared_secret).and_return('abc123')
    end

    it "ensures a valid message from Chargify" do
      @request.env["HTTP_X_CHARGIFY_WEBHOOK_SIGNATURE_HMAC_SHA_256"] = "2867470cda8601e4031a02d1bb8522f3afb447ed95b3274c99f2a5f3d028098c"
      post :webhook, 'id=15413743&event=test&payload[chargify]=testing'

      assert_response :success
    end

    it "rejects an invalid message from Chargify" do
      @request.env["HTTP_X_CHARGIFY_WEBHOOK_SIGNATURE_HMAC_SHA_256"] = 'foo'
      post :webhook, 'id=15413743&event=test&payload[chargify]=testing'

      assert_response 401
    end

    it "delegates to account to update relevant info" do
      @account = create(:account)

      # Sending just the hash results in ordering issues.  So we sign the fake body instead
      body = "id=15413743&event=test&payload[subscription][customer][reference]=#{@account.id}"
      sig  = OpenSSL::HMAC.hexdigest('sha256', Chargify.shared_secret, body)
      @request.env["HTTP_X_CHARGIFY_WEBHOOK_SIGNATURE_HMAC_SHA_256"] = sig
      @request.env['RAW_POST_DATA'] = body


      post :webhook,
        id: 15413743,
        event: 'test',
        payload: {
          subscription: {
            customer: {
              reference: @account.id
            }
          }
        }

      assert_response :success
    end
  end

end
