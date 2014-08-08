class AccountEmailsController < ApplicationController
  respond_to :json

  def show
    new_account = Account.new(slug: params[:id])
    render json: new_account.email_errors, status: new_account.email_errors.empty? ? :not_found: :ok
  end
end
