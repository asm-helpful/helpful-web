class CreateRespondLaters < ActiveRecord::Migration
  def change
    create_table :respond_laters, id: :uuid do |t|
      t.uuid :conversation_id, null: false
      t.uuid :user_id, null: false

      t.timestamps
    end
  end
end
