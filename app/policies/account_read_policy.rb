class AccountReadPolicy < Policy

  def initialize(account, user)
    @account = account
    @user = user
  end

  def access?
    @account && @account.users.include?(@user)
  end

end
