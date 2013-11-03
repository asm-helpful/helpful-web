class AddUniqueIndexToAccounts < ActiveRecord::Migration
  def change
    add_index :accounts, :name, unique: true
  end
end
