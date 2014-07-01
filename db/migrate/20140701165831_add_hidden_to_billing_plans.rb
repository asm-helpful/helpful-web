class AddHiddenToBillingPlans < ActiveRecord::Migration
  def change
    add_column :billing_plans, :hidden, :boolean, default: false, null: false
  end
end
