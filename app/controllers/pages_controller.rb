class PagesController < ApplicationController

  def home
    @plans = BillingPlan.visible.order('price ASC')
  end

  def embed
    redirect_to ActionController::Base.helpers.javascript_path('embed.js')
  end

  def docs
  end

end
