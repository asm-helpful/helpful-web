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
      sign_in(@new_account_user)
      redirect_to conversations_index_path
    else
      render 'new'
    end
  end
end
