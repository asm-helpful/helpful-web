class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :update]

  def edit
    find_account!
  end

  def update
    find_account!

    begin
      current_user.transaction do
        current_user.update!(user_params)
        current_user.person.update!(person_params)
      end

      flash[:notice] = 'Your settings were updated successfully!'
      redirect_to edit_user_path
    rescue ActiveRecord::RecordInvalid
      render :edit
    end
  end

  def find_account!
    # FIXME: This is a hack while we split out user settings from account
    #        settings.
    @account = current_user.accounts.first
  end

  def person_params
    params.require(:user).permit(:name, :email).merge(params.require(:person).permit(:username, :avatar))
  end

  def user_params
    { email: person_params[:email] }
  end
end
