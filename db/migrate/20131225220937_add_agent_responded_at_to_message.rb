class AddAgentRespondedAtToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :agent_responded_at, :datetime
    add_index :messages, :agent_responded_at
  end
end
