require 'test_helper'

describe Settings::PaymentsController do
  test 'GET edit' do
    m = FactoryGirl.create(:membership)

    current_user = m.user
    sign_in(current_user)

    get :edit

    assert_response :success
  end
end