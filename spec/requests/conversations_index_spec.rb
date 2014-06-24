require 'spec_helper'

describe 'showing all converastions' do
  let!(:user) { create(:user_with_account) }
  let(:account) { user.accounts.first }
  let!(:inbox_conversation) { create(:conversation, account: account, archived: false) }
  let!(:archive_conversation) { create(:conversation, account: account, archived: true) }
  let!(:unpaid_conversation) { create(:conversation, account: account, archived: false, hidden: true) }

  before { login_as(user) }

  it 'shows all authorized conversations' do
    get "/accounts/#{account.id}/conversations.json"

    expect(response.status).to eq(200)
    expect(response.body).to have_json_size(2).at_path('conversations')
  end

  it 'shows all conversations in the inbox when specified' do
    get "/accounts/#{account.id}/conversations.json?archived=false"

    expect(response.status).to eq(200)
    expect(response.body).to have_json_size(1).at_path('conversations')
  end

  it 'shows all archived conversations when specified' do
    get "/accounts/#{account.id}/conversations.json?archived=true"

    expect(response.status).to eq(200)
    expect(response.body).to have_json_size(1).at_path('conversations')
  end
end
