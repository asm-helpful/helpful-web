class AddUserIdToConversationsAgain < ActiveRecord::Migration
  def change
    add_column :conversations, :user_id, :uuid
    add_index :conversations, :user_id
  end
end
