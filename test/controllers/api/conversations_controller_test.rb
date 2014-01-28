require 'test_helper'

describe Api::ConversationsController, :index do
  setup do
    @current_user = create(:user)
    create(:person, user: @current_user)
    sign_in(@current_user)
    @conversation = create(:conversation_with_messages)
  end

  test "finds the account" do
    get :index
    assert_not_nil assigns(:account)
  end

  test "renders the accounts conversations" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conversations)
  end
end
