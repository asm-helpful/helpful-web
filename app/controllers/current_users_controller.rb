class CurrentUsersController < ApplicationController
  before_action :authenticate_user!,
    only: [:show]

  respond_to :json

  def show
    respond_with current_user
  end
end
