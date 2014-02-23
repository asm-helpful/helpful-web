class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :update]

  def edit
    # FIXME: This is a hack while we split out user settings from account
    #        settings.
    @account = current_user.accounts.first
  end

end
