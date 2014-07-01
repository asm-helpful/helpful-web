class AddWebhookToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :webhook, :json
  end
end
