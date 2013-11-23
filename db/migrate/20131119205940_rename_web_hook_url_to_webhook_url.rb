class RenameWebHookUrlToWebhookUrl < ActiveRecord::Migration
  def change
    rename_column :accounts, :web_hook_url, :webhook_url
  end
end
