class CreateTagEvents < ActiveRecord::Migration
  def change
    create_table :tag_events do |t|
      t.uuid :conversation_id
      t.uuid :user_id
      t.string :tag

      t.timestamps
    end

    add_index :tag_events, :conversation_id
  end
end
