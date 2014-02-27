class Api::AccountsController < ApiController

  def index
    @accounts = current_user.accounts
    respond_with(@accounts)
  end

end
