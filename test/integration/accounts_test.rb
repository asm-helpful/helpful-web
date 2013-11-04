require 'test_helper'

class AccountsTest < IntegrationSpec
  it "creates a new account" do
    visit '/account/new'
    fill_in 'Company name', with: 'MyCompany'
    fill_in 'Email', with: 'user2@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
    page.must_have_content 'You have successfully signed up!  Try logging in!'
  end
end
