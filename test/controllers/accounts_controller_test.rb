require "test_helper"

describe AccountsController do

  test "GET new" do
    get :new
    assert_response :success
  end

  test "POST create" do
    post :create, {
      account: {
        name: 'MyCompany'
      },
      person: {
        name: 'John Doe'
      },
      user: {
        email: 'user@user.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }

    assert_redirected_to inbox_account_conversations_path('mycompany')
  end

  test "PATCH update" do
    m = FactoryGirl.create(:membership)

    @account = m.account
    sign_in(m.user)

    patch :update, id: @account.slug,
      account: {
        name: 'MyCompany2'
      }

    assert_redirected_to edit_account_url(@account)
    assert_equal 'MyCompany2', @account.reload.name
  end

end
