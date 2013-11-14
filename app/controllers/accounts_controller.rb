class AccountsController < ApplicationController
  def new
    @account = Account.new
    @new_account_user = User.new
    @person = Person.new
  end

  def create
    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    account_params = params.require(:account).permit(:name)
    person_params = params.require(:person).permit(:name)

    @new_account_user = User.new user_params
    @account = Account.new account_params
    @person = Person.new person_params

    @person.email = @new_account_user.email
    
    @account.new_account_user = @new_account_user
    @new_account_user.person = @person

    if @new_account_user.valid? && @account.valid? && @person.valid? && @account.save
      Analytics.identify(
          user_id: @new_account_user.id,
          traits: { email: @new_account_user.email, account_id: @account.id })
      Analytics.track(
          user_id: @new_account_user.id,
          event: 'Signed Up')
      redirect_to root_url, notice: 'You have successfully signed up!  Try logging in!'
    else
      render 'new'
    end
  end
end
