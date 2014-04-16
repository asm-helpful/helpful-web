class Api::AccountsController < ApiController

  def index
    @accounts = current_user.accounts
    respond_with(@accounts)
  end

  def show
    find_account!
    respond_with(@account)
  end

  def update
    find_account!
    @account.update(account_params)
    respond_with(@account)
  end

  private

  def find_account!
    @account = Account.find_by!(id: params.fetch(:id))
    authorize! AccountReadPolicy.new(@account, current_user)
  end

  def account_params
    params.permit(:name, :website_url, :webhook_url, :prefers_archiving)
  end

end
