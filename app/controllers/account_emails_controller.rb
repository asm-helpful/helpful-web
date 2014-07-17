class AccountEmailsController < ApplicationController
  respond_to :json

  def show
    render nothing: true,
      status: account_exists? ? :ok : :not_found
  end

  def account_exists?
    Account.where(slug: params[:id]).exists?
  end
end
