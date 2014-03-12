require 'spec_helper'

describe CannedResponsesController do
  let!(:account) { create(:account) }
  let!(:user) { create(:user) }
  let!(:membership) { create(:membership, user: user, account: account, role: 'agent') }

  before do
    sign_in(user)
  end

  it 'shows all canned responses for the account' do
    canned_response = create(:canned_response, account: account)
    another_canned_response = create(:canned_response)

    get :index, account_id: account.slug

    expect(assigns(:canned_responses)).to eq([canned_response])
  end

  it 'creates a canned response' do
    post :create,
      {
        account_id: account.slug,
        canned_response: {
          key: 'refund',
          message: 'You will be refunded for your last month of service.'
        }
      }

    canned_response = account.canned_responses.first

    expect(canned_response).to be_present
    expect(canned_response.key).to eq('refund')
  end

  it 'edits a canned response' do
    canned_response = create(:canned_response, account: account, key: 'refund', message: 'You will be refunded for your last month of service.')

    post :update,
      {
        id: canned_response.id,
        account_id: account.slug,
        canned_response: {
          key: 'refund-month',
          message: 'You will be refunded for your last month of service.'
        }
      }

    canned_response.reload

    expect(canned_response).to be_present
    expect(canned_response.key).to eq('refund-month')
  end

  it 'destroys a canned response' do
    canned_response = create(:canned_response, account: account)

    delete :destroy, id: canned_response.id, account_id: account.slug

    expect(CannedResponse.where(id: canned_response.id).exists?).to eq(false)
  end
end
