require 'spec_helper'

describe "new user signup" do
  it 'allows the user to fill out the form and sign up' do
    visit root_path
    find(".button-sign-up").click
    fill_in "account_name", :with => "Helpful"
    fill_in "person_first_name", :with => "Jess"
    fill_in "person_last_name", :with => "Brown"
    fill_in "user_email", :with => "helper@helpful.io"
    fill_in "user_password", :with => "xxx12223xxx"
    click_on "Finish Sign Up!"
    expect(page).to have_selector(".alert", text: "Welcome to Helpful!")
    expect(page).to have_selector(".navbar .navbar-text", text: "Helpful")
  end

  context "when filling out the form with something invalid" do
    it 'returns the user to the page with an error message' do
      visit root_path
      find(".button-sign-up").click
      fill_in "account_name", :with => "Helpful"
      fill_in "person_first_name", :with => "Jess"
      fill_in "person_last_name", :with => "Brown"
      fill_in "user_email", :with => "helper@helpful.io"
      fill_in "user_password", :with => "short"
      click_on "Finish Sign Up!"
      expect(page).to have_selector("h2", text: "1 error prohibited this record from being saved")
      expect(page).to have_selector("body", "Password is too short (minimum is 8 characters)")
    end
  end
end
