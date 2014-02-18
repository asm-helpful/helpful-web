require 'test_helper'

describe DashboardController do

  test 'GET #show' do
    sign_in_as_admin
    get :show
  end

end
