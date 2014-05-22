class CannedResponseSerializer < BaseSerializer
  include MarkdownHelper

  attributes :rendered_message

  def rendered_message
    markdown(object.message)
  end
end
