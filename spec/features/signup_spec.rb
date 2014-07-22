require 'spec_helper'

describe "new user signup" do
  it 'allows the user to fill out the form and sign up' do
    visit root_path
    find('[rel="signup"]').click
    fill_in "account_name", :with => "Helpful"
    fill_in "person_name", :with => "Jess Brown"
    fill_in "user_email", :with => "helper@helpful.io"
    fill_in "user_password", :with => "xxx12223xxx"
    click_on "Sign up and start using Helpful!"
    expect(page).to have_selector('h1', text: "Try it out and see how Helpful works.")
  end

  context "when filling out the form with something invalid" do
    it 'returns the user to the page with an error message' do
      visit root_path
      find('[rel="signup"]').click
      fill_in "account_name", :with => "Helpful"
      fill_in "person_name", :with => "Jess Brown"
      fill_in "user_email", :with => "helper@helpful.io"
      fill_in "user_password", :with => "short"
      click_on "Sign up and start using Helpful!"
      expect(page).to have_selector(".panel-title", text: "Oops! Something went wrong.")
      expect(page).to have_selector("body", "Password is too short (minimum is 8 characters)")
    end
  end
end
