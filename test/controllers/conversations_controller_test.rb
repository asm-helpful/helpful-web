require 'test_helper'

describe ConversationsController, :index do
  setup do
    @current_user = create(:user)
    create(:person, user: @current_user)
    sign_in(@current_user)
    @conversation = create(:conversation_with_messages)
  end

  test "finds the account" do
    get :inbox, account_id: @conversation.account.slug
    assert_not_nil assigns(:account)
  end

  test "renders the accounts inbox" do
    get :inbox, account_id: @conversation.account.slug
    assert_response :success
    assert_not_nil assigns(:conversations)
  end

  test "assigns an agent to an unread conversation" do
    get :show,
      id: @conversation.number,
      account_id: @conversation.account.slug

    assert_response :success
    assert_equal @conversation.reload.agent, @current_user
  end
end
