class PagesController < ApplicationController

  def home
    @beta_invite = BetaInvite.new
  end

end
