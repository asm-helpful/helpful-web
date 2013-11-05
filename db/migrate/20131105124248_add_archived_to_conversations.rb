class AddArchivedToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :archived, :boolean, :default => false
  end
end
