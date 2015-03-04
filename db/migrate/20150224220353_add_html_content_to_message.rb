class AddHtmlContentToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :html_content, :text, default: ''
  end
end
