class CreateAssignmentEvents < ActiveRecord::Migration
  def change
    create_table :assignment_events do |t|
      t.uuid :conversation_id
      t.uuid :user_id
      t.uuid :assignee_id

      t.timestamps
    end

    add_index :assignment_events, :conversation_id
  end
end
