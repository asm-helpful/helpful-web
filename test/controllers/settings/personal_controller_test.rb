require 'test_helper'

describe Settings::PersonalController do
  test 'GET edit' do
    m = FactoryGirl.create(:membership)

    current_user = m.user
    sign_in(current_user)

    get :edit

    assert_response :success
  end

  test 'PATCH update' do
    m = FactoryGirl.create(:membership)

    current_user = m.user
    sign_in(current_user)

    patch :update, { user: { name: 'Road Runner' } }

    assert_redirected_to edit_settings_personal_url
    assert_equal 'Road Runner', current_user.reload.name
  end
end