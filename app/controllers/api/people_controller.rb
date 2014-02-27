class Api::PeopleController < ApiController

  def index
    find_account!
    respond_with(@account.people)
  end

  protected

  def find_account!
    @account = Account.find_by!(id: params.fetch(:account))
  end

end
