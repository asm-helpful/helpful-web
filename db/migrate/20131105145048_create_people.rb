class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people, id: false do |t|
      t.primary_key :id, :uuid, default: nil
      t.uuid   :user_id
      t.string :name
      t.string :email
      t.string :twitter

      t.timestamps
    end

    add_index :people, :user_id, unique: true
    add_index :people, :email,   unique: true
    add_index :people, :twitter, unique: true
  end
end
