class PagesController < ApplicationController

  def home
    @beta_invite = BetaInvite.new
  end

  def embed
    redirect_to ActionController::Base.helpers.javascript_path('embed.js')
  end

  def docs
    renderer = Redcarpet::Render::HTML.new#, :no_links => true, :hard_wrap => true
    markdown = Redcarpet::Markdown.new renderer#, :autolink => true, :space_after_headers => true
    text = markdown.render(File.read(Rails.root.join('app','views','pages','docs.md'))).html_safe
    render inline: text, layout: true
  end

end
