class AddWebsiteToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :website_url, :string
  end
end
