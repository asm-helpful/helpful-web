class AddFowardingAddressToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :forwarding_address, :string
  end
end
