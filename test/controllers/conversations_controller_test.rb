require 'test_helper'

describe ConversationsController do
  setup do
    @conversation = FactoryGirl.create(:conversation_with_messages)
  end

  test "should set account" do
    get :index, account: @conversation.account.slug
    assert_response :success
    assert_not_nil assigns(:account)
  end

  test "should render conversation for account" do
    get :index, account: @conversation.account.slug
    assert_response :success
    assert_not_nil assigns(:conversations)

    assert_select '.conversation', 1
  end

  test "should raise RecordNotFound with no supplied account" do
    skip "Disabled until multi-account support setup"
    assert_raises(ActiveRecord::RecordNotFound) do
      get :index
    end
  end


end
