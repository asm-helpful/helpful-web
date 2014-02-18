class Settings::PaymentsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  before_filter :build_account

  def edit
  end

  def update
  end

  private

  def build_account
    @account = current_user.primary_owned_account
  end
end