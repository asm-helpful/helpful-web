class Settings::PersonalController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  before_filter :build_account, :build_person

  def edit
  end

  def update
    respond_to do |format|
      if @person.update_attributes(personal_params)
        format.html { redirect_to edit_settings_personal_url, notice: "Personal settings updated" }
      else
        format.html { render 'edit' }
      end
    end
  end

  private

  def build_person
    @person = current_user.person
  end

  def build_account
    @account = current_user.primary_owned_account
  end

  def personal_params
    params.require(:person).permit(:name, :email)
  end
end