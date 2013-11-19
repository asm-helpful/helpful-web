class AddAccountIdToPerson < ActiveRecord::Migration
  def change
    add_column :people, :account_id, :uuid
  end
end
