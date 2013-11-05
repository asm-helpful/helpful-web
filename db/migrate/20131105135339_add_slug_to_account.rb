class AddSlugToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :slug, :string, null: false
    add_index :accounts, :slug, unique: true
  end
end
