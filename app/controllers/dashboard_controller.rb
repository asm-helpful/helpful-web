class DashboardController < ApplicationController

  def show
    authenticate_user!
    # FIXME: This is a handy hack
    @account = current_user.accounts.first
    redirect_to inbox_account_conversations_path(@account)
  end

end
