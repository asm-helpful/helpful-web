module AdminAuth

  def sign_in_as_admin
    @membership = FactoryGirl.create(:membership)
    @account = @membership.account
    @current_user = @membership.user
    sign_in(@current_user)
  end

end
