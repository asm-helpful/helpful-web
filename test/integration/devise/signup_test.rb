require 'test_helper'

class SignupTest < IntegrationSpec
  it "signs me up" do
    visit '/users/sign_up'
    fill_in 'Email', :with => 'user2@example.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password confirmation', :with => 'password'
    click_button 'Sign up'
    page.must_have_content 'Welcome! You have signed up successfully.'
  end
end
