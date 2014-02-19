require 'test_helper'

describe DashboardController do

  test 'GET #show' do
    sign_in_as_admin
    get :show
    assert_redirected_to inbox_account_conversations_path(@account)
  end

end
