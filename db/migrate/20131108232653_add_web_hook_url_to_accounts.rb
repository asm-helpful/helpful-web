class AddWebHookUrlToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :web_hook_url, :string
  end
end
