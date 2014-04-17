class AddDefaultBillingPlanToAccounts < ActiveRecord::Migration
  def change
    Account.where(:billing_plan => nil).each do |account|
      account.billing_plan = BillingPlan.find_by_slug('starter-kit')
      account.save
    end
  end
end
