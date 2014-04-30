class AddHiddenToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :hidden, :bool, null: false, default: false
  end
end
