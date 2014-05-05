class ChangeConversationArchivedToBoolean < ActiveRecord::Migration
  def up
    add_column :conversations, :archived, :boolean, default: false
    Conversation.unscoped.where(
      status: 'archived'
    ).update_all(
      archived: true
    )
    remove_column :conversations, :status
  end

  def down
    add_column :conversations, :status, :string
    Conversation.unscoped.where(
      archived: true
    ).update_all(
      status: 'archived'
    )
    remove_column :conversations, :archived
  end

end
