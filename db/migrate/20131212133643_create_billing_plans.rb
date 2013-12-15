class CreateBillingPlans < ActiveRecord::Migration
  def change
    create_table :billing_plans, id: false do |t|
      t.primary_key :id, :uuid, default: nil
      t.string :slug
      t.string :name
      t.string :chargify_product_id
      t.integer :max_conversations
      t.decimal :price

      t.timestamps
    end
  end
end
