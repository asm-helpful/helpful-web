require 'redcarpet'

module MarkdownHelper

  def markdown(str)
    md = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      autolink: true,
      space_after_headers: true,
      strikethrough: true,
      no_intra_emphasis: true
    )
    md.render(str)
  end

end
