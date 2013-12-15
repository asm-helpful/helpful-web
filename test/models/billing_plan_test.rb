require "test_helper"

describe BillingPlan do
  before do
    @billing_plan = BillingPlan.new
  end

  it "must be valid" do
    @billing_plan.valid?.must_equal true
  end
end
