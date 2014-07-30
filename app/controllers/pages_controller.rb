class PagesController < ApplicationController

  def home
  end

  def embed
    redirect_to ActionController::Base.helpers.javascript_path('embed.js')
  end

  def docs
  end

end
