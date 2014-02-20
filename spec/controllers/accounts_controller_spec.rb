require "spec_helper"

describe AccountsController do
  it "GET new" do
    get :new
    assert_response :success
  end

  it "POST create" do
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

end
