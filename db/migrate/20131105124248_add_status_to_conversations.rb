class AddStatusToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :status, :string
  end
end
