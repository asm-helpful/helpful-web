class AttachmentSerializer < BaseSerializer
  attributes :url, :file_size, :content_type

  def url
    object.file.url
  end

end
