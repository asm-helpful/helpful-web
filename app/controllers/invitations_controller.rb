class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def index
    find_account!
  end

  private

  def find_account!
    @account = Account.find_by!(slug: params.fetch(:id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end
end
