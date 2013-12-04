class RemoveUniqueIndexOnPersonEmail < ActiveRecord::Migration
  def change
    [:email, :twitter, :user_id].each do |col|
      remove_index :people, [col]
      add_index :people, [col], unique: false
    end
  end
end
