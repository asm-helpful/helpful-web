class AddBillingToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :chargify_subscription_id, :string
    add_column :accounts, :chargify_customer_id, :string
    add_column :accounts, :billing_plan_id, :uuid
    add_column :accounts, :billing_status, :string
    add_column :accounts, :chargify_portal_url, :string
    add_column :accounts, :chargify_portal_valid_until, :datetime

    add_index  :accounts, :billing_plan_id
    add_index  :accounts, :chargify_subscription_id
  end
end
