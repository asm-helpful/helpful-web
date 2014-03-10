class CreateConversationMailboxes < ActiveRecord::Migration
  def change
    create_table :conversation_mailboxes, id: false do |t|
      t.primary_key :id, :string, default: nil
      t.uuid :conversation_id
      t.uuid :account_id
      t.timestamps
    end
  end
end