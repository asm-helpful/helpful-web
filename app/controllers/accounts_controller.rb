class AccountsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  respond_to :html

  def new
    @account = Account.new
    @new_account_user = User.new
    @person = Person.new
  end

  def create
    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    account_params = params.require(:account).permit(:name)
    person_params = params.require(:person).permit([:name, :username])

    @new_account_user = User.new user_params
    @account = Account.new account_params
    @person = Person.new person_params

    @person.email = @new_account_user.email
    @person.account = @account

    @account.new_account_user = @new_account_user
    @new_account_user.person = @person

    if @new_account_user.valid? && @account.valid? && @person.valid? && @account.save

      sign_in(@new_account_user)

      Analytics.identify(
          user_id: @new_account_user.id,
          traits: { email: @new_account_user.email, account_id: @account.id })
      Analytics.track(
          user_id: @new_account_user.id,
          event: 'Signed Up')

      redirect_to inbox_account_conversations_path(@account), notice: 'Welcome to Helpful!'
    else
      render 'new'
    end
  end

  def show
    find_account!
    redirect_to inbox_account_conversations_path(@account)
  end

  def edit
    find_account!
    @user = User.new
  end

  def update
    find_account!
    @account.update(account_params)
    respond_with(@account)
  end

  def web_form
    find_account!
  end

  private

  def find_account!
    @account = Account.find_by!(slug: params.fetch(:id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end

  def account_params
    params.require(:account).permit(:name, :website_url, :webhook_url, :prefers_archiving, :signature)
  end

end
