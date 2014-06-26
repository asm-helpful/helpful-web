class DropRespondLatersTable < ActiveRecord::Migration
  def change
    drop_table :respond_laters
  end
end
