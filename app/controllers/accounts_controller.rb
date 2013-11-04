class AccountsController < ApplicationController
  def new
    @account = Account.new
    @new_account_user = User.new
  end

  def create
    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    account_params = params.require(:account).permit(:name)

    @new_account_user    = User.new user_params
    @account = Account.new account_params
    @account.new_account_user = @new_account_user

    if @new_account_user.valid? && @account.valid? && @account.save
      redirect_to root_url, notice: 'You have successfully signed up!  Try logging in!'
    else
      render 'new'
    end
  end
end
