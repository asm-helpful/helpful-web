class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks, id: false do |t|
      t.primary_key :id, :uuid, default: nil

      t.uuid     "account_id",  null: false
      t.string   "event",       null: false
      t.text     "body"

      t.string   "response_code"
      t.text     "response_body"
      t.datetime "response_at"

      t.timestamps
    end

    add_index :webhooks, :account_id
    add_index :webhooks, [:response_code, :response_at]

    add_column :accounts, :webhook_secret, :string
  end
end
