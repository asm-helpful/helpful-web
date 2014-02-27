class AddTagsToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :tags, :string, array: true, default: '{}'
  end
end
