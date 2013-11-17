require 'test_helper'

class ConversationsControllerTest < ActionController::TestCase

  setup do
    @account = create(:account)
    @conversation = create(:conversation_with_messages, account: @account)
  end

  def test_index_success
    get :index, account: @account.to_param
    assert_response :success
  end

  def test_index_assigns_account
    get :index, account: @account.to_param
    assert_not_nil assigns(:account)
  end

  def test_index_assigns_conversations
    get :index, account: @account.to_param
    assert_not_nil assigns(:conversations)
  end

  def test_index_not_found_without_account
    skip "Disabled until multi-account support setup"
    assert_raises(ActiveRecord::RecordNotFound) do
      get :index
    end
  end

end
