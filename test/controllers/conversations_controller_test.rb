require 'test_helper'

describe ConversationsController do
  setup do
    @current_user = FactoryGirl.create(:user)
    sign_in @current_user
    @conversation = FactoryGirl.create(:conversation_with_messages)
  end

  test "should set account" do
    puts "!!!#{@conversation.account.slug}  #{@conversation.account.inspect}"
    get :index, account: @conversation.account.slug
    assert_response :success
    assert_not_nil assigns(:account)
  end

  test "should render conversation for account" do
    get :index, account: @conversation.account.slug
    assert_response :success
    assert_not_nil assigns(:conversations)
  end
end
