class AddAsmSignupPromotionCompletedAtToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :asm_signup_promotion_completed_at, :datetime
  end
end
