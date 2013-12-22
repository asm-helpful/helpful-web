class AddInternalToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :internal, :boolean, default: false
  end
end
