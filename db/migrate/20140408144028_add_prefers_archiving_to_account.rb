class AddPrefersArchivingToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :prefers_archiving, :boolean
  end
end
