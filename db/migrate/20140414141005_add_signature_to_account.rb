class AddSignatureToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :signature, :text
  end
end
