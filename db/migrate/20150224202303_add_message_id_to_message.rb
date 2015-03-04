class AddMessageIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :message_id, :text, index: true
    add_column :messages, :in_reply_to_id, :uuid, index: true
  end
end
