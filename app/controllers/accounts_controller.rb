class AccountsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :show]
  before_action :find_account!, only: [:edit, :update, :show]
  respond_to :html

  def new
    @account = Account.new
    @user = User.new
    @person = Person.new
  end

  def create
    @account = Account.new(account_params)
    @user = User.new(user_params)

    @person = Person.where(email: @user.email).first_or_initialize
    @person.assign_attributes(person_params)
    @person.account = @account
    @person.user = @user

    begin
      ActiveRecord::Base.transaction do
        [@user, @account, @person].each(&:valid?)

        @user.save!
        @account.save!
        @person.save!

        @account.add_owner!(@user)
      end

      # TODO: Use flag in conversation model to check for these
      ProtipConversation.create(@account, current_user) unless @account.conversations.protip_conversation.exists?
      WidgetConversation.create(@account, current_user) unless @account.conversations.widget_conversation.exists?
      WelcomeConversation.create(@account, current_user) unless @account.conversations.welcome_conversation.exists?

      sign_in(@user)

      if Rails.env.production?
        Analytics.identify(user_id: @user.id, traits: { email: @user.email, account_id: @account.id })
        Analytics.track(user_id: @user.id, event: 'Signed Up')

        Customerio.client.identify(
          id: @user.id,
          created_at: @user.created_at.to_i,
          name: @user.name,
          email: @user.email
        )
      end

      redirect_to inbox_account_conversations_path(@account)
    rescue ActiveRecord::RecordInvalid
      render 'new'
    end
  end

  def invite
    find_account!
  end

  def show
    redirect_to inbox_account_conversations_path(@account)
  end

  def edit
    @user = User.new
  end

  def update
    @account.update(account_params)
    respond_with(@account)
  end

  def demo
    find_account!
  end

  def setup
    find_account!
  end

  def web_form
    find_account!
  end

  def help
    find_account!
  end

  private

  def find_account!
    @account = Account.find_by(slug: params.fetch(:id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end

  def account_params
    params.require(:account).permit([
      :name, :website_url, :webhook_url, :prefers_archiving, :signature,
      :email, :stripe_subscription_id, :forwarding_address
    ])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def person_params
    params.require(:person).permit(:name, :username)
  end
end
