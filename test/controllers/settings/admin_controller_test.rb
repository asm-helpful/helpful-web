require 'test_helper'

describe Settings::AdminController do
  test 'GET edit' do
    m = FactoryGirl.create(:membership)

    current_user = m.user
    sign_in(current_user)

    get :edit

    assert_response :success
  end

  test 'PATCH update' do
    m = FactoryGirl.create(:membership)

    @account = m.account
    sign_in(m.user)

    patch :update, {
      account: {
        name: 'MyCompany2'
      }
    }

    assert_redirected_to edit_settings_admin_url
    assert_equal 'MyCompany2', @account.reload.name
  end
end