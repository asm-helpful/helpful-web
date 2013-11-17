require "test_helper"

class AccountsControllerTest < ActionController::TestCase

  def test_new_success
    get :new
    assert_response :success
  end

  def test_create_redirects_to_root
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
