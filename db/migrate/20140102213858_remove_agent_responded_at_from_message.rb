class RemoveAgentRespondedAtFromMessage < ActiveRecord::Migration
  def change
    remove_index :messages, :agent_responded_at
    remove_column :messages, :agent_responded_at, :datetime
  end
end
