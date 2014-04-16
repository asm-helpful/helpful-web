class AddUserNameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :username, :string
    add_index(:people, [:account_id, :username], unique: true)
  end
end
