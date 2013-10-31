class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts, id: false do |t|
      t.primary_key :id, :uuid, default: nil
      t.string :name
      t.timestamps
    end

    add_column :conversations, :account_id, :uuid, null: false
  end
end
