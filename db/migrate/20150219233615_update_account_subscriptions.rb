class UpdateAccountSubscriptions < ActiveRecord::Migration
  def change
    remove_column :accounts, :chargify_subscription_id, :string
    remove_column :accounts, :chargify_customer_id, :string
    remove_column :accounts, :billing_plan_id, :uuid
    remove_column :accounts, :billing_status, :string
    remove_column :accounts, :chargify_portal_url, :string
    remove_column :accounts, :chargify_portal_valid_until, :datetime

    add_column :accounts, :is_pro, :boolean, default: false, null: false

    drop_table :billing_plans
  end
end
