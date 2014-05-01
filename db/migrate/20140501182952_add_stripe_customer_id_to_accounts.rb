class AddStripeCustomerIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :stripe_customer_id, :string
  end
end
