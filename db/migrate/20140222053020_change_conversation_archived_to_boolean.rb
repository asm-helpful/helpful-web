class ChangeConversationArchivedToBoolean < ActiveRecord::Migration
  def up
    add_column :conversations, :archived, :boolean, default: false
    Conversation.where(
      status: 'archived'
    ).update_all(
      archived: true
    )
    remove_column :conversations, :status
  end

  def down
    add_column :conversations, :status, :string
    Conversation.where(
      archived: true
    ).update_all(
      status: 'archived'
    )
    remove_column :conversations, :archived
  end

end
