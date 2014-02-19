class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise: Where to redirect users once they have logged in
  # FIXME Subclass SessionsController to directly set the account.
  def after_sign_in_path_for(resource)
    inbox_account_conversations_path(resource.accounts.first)
  end

end
