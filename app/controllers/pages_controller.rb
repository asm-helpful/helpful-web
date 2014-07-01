class PagesController < ApplicationController

  def home
    @plans = BillingPlan.visible.order('price ASC')
  end

  def embed
    redirect_to ActionController::Base.helpers.javascript_path('embed.js')
  end

  def docs
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer)
    text = markdown.render(Rails.root.join('apiary.apib').read).html_safe
    render inline: text, layout: true
  end

end
