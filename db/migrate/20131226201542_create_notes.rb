class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes, :id => :uuid do |t|
      t.text :content
      t.uuid :user_id, null: false
      t.uuid :conversation_id, null: false
      t.timestamps
    end
  end
end
