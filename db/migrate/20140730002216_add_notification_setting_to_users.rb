class AddNotificationSettingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_setting, :string, default: 'message', null: false
  end
end
