class RemoveHiddenFromConversations < ActiveRecord::Migration
  def change
    remove_column :conversations, :hidden, :boolean
  end
end
