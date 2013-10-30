class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages, id: false do |t|
      t.primary_key :id, :uuid, default: nil
      t.integer :number
      t.string :from
      t.text :body
      t.timestamps
    end
  end
end
