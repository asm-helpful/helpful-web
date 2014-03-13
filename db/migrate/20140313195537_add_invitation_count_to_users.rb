class AddInvitationCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invitations_count, :integer, default: 0
  end
end
