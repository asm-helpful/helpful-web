class NewWindowLinkRenderer < Redcarpet::Render::HTML
  def initialize(extensions = {})
    super extensions.merge(link_attributes: { target: '_blank' })
  end
end
