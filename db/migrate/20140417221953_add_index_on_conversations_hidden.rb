class AddIndexOnConversationsHidden < ActiveRecord::Migration
  def change
    add_index :conversations, :hidden
  end
end
