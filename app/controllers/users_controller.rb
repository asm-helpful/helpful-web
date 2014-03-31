class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :update]

  def edit
    find_account!
  end

  def update
    find_account!

    if current_user.update(user_params)
      flash[:notice] = 'Your settings were updated successfully!'
      redirect_to edit_user_path
    else
      render :edit
    end
  end

  def find_account!
    # FIXME: This is a hack while we split out user settings from account
    #        settings.
    @account = current_user.accounts.first
  end

  def user_params
    person_params = params.require(:user).permit(:name, person_attributes: [:name, :email])
    person_params.merge(email: person_params[:person_attributes][:email])
  end
end
