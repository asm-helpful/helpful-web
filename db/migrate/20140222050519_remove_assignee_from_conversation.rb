class RemoveAssigneeFromConversation < ActiveRecord::Migration
  def change
    remove_column :conversations, :user_id, :uuid
  end
end
