class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships, id: false do |t|
      t.primary_key :id, :uuid, default: nil
      t.uuid :account_id, null: false
      t.uuid :user_id, null: false
      t.string :role

      t.timestamps
    end

    add_index :memberships, [:account_id, :user_id], unique: true
    add_index :memberships, :user_id
  end
end
