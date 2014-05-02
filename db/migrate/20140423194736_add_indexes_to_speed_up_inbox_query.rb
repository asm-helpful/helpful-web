class AddIndexesToSpeedUpInboxQuery < ActiveRecord::Migration
  def change
    add_index :conversations, [:account_id, :archived]

    add_index :messages, :person_id

    add_index :respond_laters, [:conversation_id, :user_id, :updated_at], name: 'index_respond_later_inbox'
  end
end
