class CreateCannedResponses < ActiveRecord::Migration
  def change
    create_table :canned_responses, id: :uuid do |t|
      t.string :key, null: false
      t.text :message, null: false
      t.uuid :account_id, null: false

      t.timestamps
    end

    add_index :canned_responses, [:key, :account_id], unique: true
  end
end
