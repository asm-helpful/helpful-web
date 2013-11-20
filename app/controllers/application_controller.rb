class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise: Where to redirect users once they have logged in
  def after_sign_in_path_for(resource)
    conversations_path(current_account)
  end

  def current_account
    # TODO this should probably be the last account you were using
    @current_account ||= current_user.accounts.first if signed_in?
  end
  helper_method :current_account
end
