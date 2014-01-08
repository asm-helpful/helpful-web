class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments, id: :uuid do |t|
      t.uuid :message_id, null: false
      t.string :file, null: false

      t.timestamps
    end
  end
end
