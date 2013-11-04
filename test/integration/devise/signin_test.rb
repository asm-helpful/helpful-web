require 'test_helper'

class SigninTest < IntegrationSpec
  #setup do
  #  Capybara.current_driver = Capybara.javascript_driver
  #end

  before :each do
    FactoryGirl.create(:user, email: 'user@example.com', password: 'password')
  end

  it "signs me in" do
    visit '/users/sign_in'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'
    page.must_have_content 'Signed in successfully'
  end
end
