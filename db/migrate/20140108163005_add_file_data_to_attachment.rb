class AddFileDataToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :content_type, :string
    add_column :attachments, :file_size, :string
  end
end
