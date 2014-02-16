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

    assert_redirected_to root_path
  end
end
