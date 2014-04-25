class AddUrlToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :url, :string
  end
end
