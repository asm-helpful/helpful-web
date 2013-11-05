class ConversationsController < ApplicationController
  before_action :load_account

  def index
    @conversations = @account.conversations.includes(:messages)
  end


  private
  def load_account
    @account = Account.where(slug: params[:account]).first!
  end
end
