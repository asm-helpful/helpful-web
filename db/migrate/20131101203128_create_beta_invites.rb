class CreateBetaInvites < ActiveRecord::Migration
  def change
    create_table :beta_invites do |t|
      t.string :email
      t.string :invite_token
      t.uuid :user_id

      t.timestamps
    end
    add_index :beta_invites, :email, unique: true
  end
end
