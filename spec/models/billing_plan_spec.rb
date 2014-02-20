require "spec_helper"

describe BillingPlan do
  before do
    @billing_plan = BillingPlan.new
  end

  it "must be valid" do
    expect(@billing_plan).to be_valid
  end
end
