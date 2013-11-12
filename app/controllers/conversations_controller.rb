class ConversationsController < ApplicationController
  before_action :load_account

  def index
    @conversations = @account.conversations.open.includes(:messages)
  end

  private

  def load_account
    @account = Account.first! # simpfy until for now
  end

end
