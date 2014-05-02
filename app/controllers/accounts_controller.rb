class AccountsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  respond_to :html

  def new
    @account = Account.new(billing_plan_slug: 'starter-kit')
    @user = User.new
    @person = Person.new
    @plans = BillingPlan.order('price ASC')
  end

  def create
    @account = Account.new(account_params)
    @user = User.new(user_params)
    @person = Person.new(person_params)
    @plans = BillingPlan.order('price ASC')

    @person.email = @user.email
    @person.account = @account
    @person.name ||= person_params[:first_name] + ' ' + person_params[:last_name]

    @user.person = @person

    begin
      ActiveRecord::Base.transaction do
        @user.save!
        @account.save!
        @person.save!

        @account.add_owner!(@user)

        @account.subscribe!
      end

      sign_in(@user)

      Analytics.identify(user_id: @user.id, traits: { email: @user.email, account_id: @account.id })
      Analytics.track(user_id: @user.id, event: 'Signed Up')

      redirect_to inbox_account_conversations_path(@account), notice: 'Welcome to Helpful!'
    rescue ActiveRecord::RecordInvalid
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
    params.require(:account).permit(:name, :website_url, :webhook_url, :prefers_archiving, :signature, :stripe_token, :billing_plan_slug)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :username)
  end
end
