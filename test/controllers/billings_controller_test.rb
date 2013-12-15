require "test_helper"
require 'openssl'

describe BillingsController do
  test "GET show" do
    sign_in_as_admin
    get :show
    assert_response :success
  end

  describe "POST webhook" do
    before do
      flexmock(Chargify, shared_secret: 'abc123')
    end

    test "ensures a valid message from Chargify" do
      @request.env["HTTP_X_CHARGIFY_WEBHOOK_SIGNATURE_HMAC_SHA_256"] = "2867470cda8601e4031a02d1bb8522f3afb447ed95b3274c99f2a5f3d028098c"
      post :webhook, 'id=15413743&event=test&payload[chargify]=testing'

      assert_response :success
    end

    test "rejects an invalid message from Chargify" do
      @request.env["HTTP_X_CHARGIFY_WEBHOOK_SIGNATURE_HMAC_SHA_256"] = 'foo'
      post :webhook, 'id=15413743&event=test&payload[chargify]=testing'

      assert_response 401
    end

    test "delegates to account to update relevant info" do
      mock_account = flexmock('mock_account')
      mock_account.should_receive(:get_update_from_chargify!).and_return(true)
      flexmock(Account).should_receive(:find).and_return(mock_account)

      @account = FactoryGirl.create(:account)

      # Sending just the hash results in ordering issues.  So we sign the fake body instead
      body = "id=15413743&event=test&payload[subscription][customer][reference]=#{@account.id}"
      sig  = OpenSSL::HMAC.hexdigest('sha256', Chargify.shared_secret, body)
      @request.env["HTTP_X_CHARGIFY_WEBHOOK_SIGNATURE_HMAC_SHA_256"] = sig
      @request.env['RAW_POST_DATA'] = body


      post :webhook, {id: 15413743, event: 'test', payload: {subscription: {customer: {reference: @account.id}}}}
      assert_response :success
    end
  end

end
