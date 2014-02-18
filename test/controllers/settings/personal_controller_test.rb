require 'test_helper'

describe Settings::PersonalController do
  test 'GET edit' do
    m = FactoryGirl.create(:membership)

    current_user = m.user
    @person = FactoryGirl.create(:person, user: current_user)
    sign_in(current_user)

    get :edit

    assert_response :success
  end

  test 'PATCH update' do
    m = FactoryGirl.create(:membership)

    current_user = m.user
    @person = FactoryGirl.create(:person, user: current_user)
    sign_in(current_user)

    patch :update, person: { name: 'Road Runner' }

    assert_redirected_to edit_settings_personal_url
    assert_equal 'Road Runner', current_user.reload.person.name
  end
end