module FeatureMacros

  def reset_email!
    ActionMailer::Base.deliveries = []
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def email_count
    ActionMailer::Base.deliveries.count
  end

  def sign_out
    visit root_path
    find(".navbar").click_link("Logout")
  end
end

module BeforeFeatureMacros

  def sign_in_owner
    sign_in_as(:user_with_account)
  end

  def sign_in_as(user_type)
    before do
      @user = create(user_type)
      visit new_user_session_path
      fill_in('user[email]', :with => @user.email)
      fill_in('user[password]', :with => attributes_for(:user)[:password])
      check('user[remember_me]')
      find(".form-actions input").click
    end
  end
end

RSpec.configure do |config|
  config.include FeatureMacros, :type => :feature
  config.extend BeforeFeatureMacros, :type => :feature
end
