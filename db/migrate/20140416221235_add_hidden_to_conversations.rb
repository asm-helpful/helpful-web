class AddHiddenToConversations < ActiveRecord::Migration
  class Conversation < ActiveRecord::Base
  end

  def change
    add_column :conversations, :hidden, :bool, null: false, default: false
  end
end
