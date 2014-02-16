class Settings::AdminController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  before_filter :build_account

  def edit
    @user = @account.users.new
  end

  def update
    respond_to do |format|
      if @account.update_attributes(account_params)
        format.html { redirect_to edit_settings_admin_url, notice: "Account settings updated" }
      else
        format.html { render 'edit' }
      end
    end
  end

  private

  def build_account
    @account = current_user.primary_owned_account
  end

  def account_params
    params.require(:account).permit(:name, :website_url, :webhook_url)
  end
end