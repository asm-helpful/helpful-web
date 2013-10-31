class CreateMessagesAndConversations < ActiveRecord::Migration

  def change
    create_table :conversations, id: false do |t|
      t.primary_key :id, :uuid, default: nil
      t.integer     :number
      t.timestamps
    end

    create_table :messages, id: false do |t|
      t.primary_key :id, :uuid, default: nil
      t.string      :type, default: nil
      t.uuid        :conversation_id, null: false
      t.string      :from
      t.text        :content
      t.hstore      :data
      t.timestamps
    end
  end

end
