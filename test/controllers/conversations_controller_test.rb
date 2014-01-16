require 'test_helper'

describe ConversationsController, :index do
  setup do
    @current_user = create(:user)
    sign_in(@current_user)
    @conversation = create(:conversation_with_messages)
  end

  test "finds the account" do
    get :index, account: @conversation.account.slug
    assert_not_nil assigns(:account)
  end

  test "renders the accounts conversations" do
    get :index, account: @conversation.account.slug
    assert_response :success
    assert_not_nil assigns(:conversations)
  end
end
