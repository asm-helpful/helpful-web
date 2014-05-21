class TextcompletesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account!

  def index
    results = TextcompleteSearch.call(@account, params[:query], params[:query_type])
    render json: results, include_root: false
  end

  def find_account!
    @account = Account.friendly.find_by!(slug: params.fetch(:account_id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end
end
