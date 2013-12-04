class PagesController < ApplicationController

  def home
    @beta_invite = BetaInvite.new
  end

  def embed
    redirect_to ActionController::Base.helpers.javascript_path('embed.js')
  end

end
