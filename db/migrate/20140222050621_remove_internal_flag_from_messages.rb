class RemoveInternalFlagFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :internal, :boolean
  end
end
