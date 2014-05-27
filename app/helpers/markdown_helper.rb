require 'redcarpet'
require 'redcarpet/render_strip'

module MarkdownHelper

  def markdown(str)
    md = Redcarpet::Markdown.new(NewWindowLinkRenderer,
      autolink: true,
      space_after_headers: true,
      strikethrough: true,
      no_intra_emphasis: true
    )
    md.render(str)
  end

  def stripdown(str)
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    renderer.render(str)
  end
end
