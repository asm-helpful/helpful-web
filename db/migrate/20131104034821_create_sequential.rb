class CreateSequential < ActiveRecord::Migration
  def change
    create_table(:sequential) do |t|
      t.string  :model
      t.string  :column
      t.string  :scope
      t.integer :scope_value
      t.integer :value
      t.timestamps
    end
  end
end
