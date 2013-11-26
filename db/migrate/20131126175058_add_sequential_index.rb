class AddSequentialIndex < ActiveRecord::Migration
  def change
    add_index :sequential, [:model, :column, :scope, :scope_value], unique: true
  end
end
