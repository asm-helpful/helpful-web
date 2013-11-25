class CreateReadReceipts < ActiveRecord::Migration
  def change
    create_table :read_receipts, id: false do |t|
      t.primary_key :id, :uuid, default: nil
      t.uuid :person_id
      t.uuid :message_id
      t.timestamps
    end

    add_index(:read_receipts, [:person_id, :message_id], :unique => true)
  end
end
