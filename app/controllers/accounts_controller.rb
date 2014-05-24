class AccountsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  respond_to :html

  def new
    @account = Account.new(billing_plan_slug: 'starter-kit')
    @user = User.new
    @person = Person.new
  end

  def create
    @account = Account.new(account_params.merge(billing_plan_slug: 'starter-kit'))
    @user = User.new(user_params)
    @person = Person.new(person_params)
    @plans = BillingPlan.order('price ASC')

    @person.email = @user.email
    @person.account = @account

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

      redirect_to account_invitations_path(@account)
    rescue ActiveRecord::RecordInvalid
      render 'new'
    end
  end

  def invite
    find_account!
  end

  def show
    find_account!
    redirect_to inbox_account_conversations_path(@account)
  end

  def edit
    find_account!

    @plans = BillingPlan.order('price ASC')
    @user = User.new
  end

  def update
    find_account!
    @account.update(account_params)
    respond_with(@account)
  end

  def configuration
    find_account!
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
    if !@account.is_user_owner(current_user)
      params.require(:account).permit(:name, :website_url, :webhook_url, :prefers_archiving, :signature)
    else
      params.require(:account).permit(:name, :website_url, :webhook_url, :prefers_archiving, :signature, :stripe_token, :billing_plan_slug)
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def person_params
    params.require(:person).permit(:name, :username)
  end
end
