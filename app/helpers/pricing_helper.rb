module PricingHelper
  def display_plans(plans)
    start = 1
    plans.each do |plan|
      range = "#{start} - #{plan.max_conversations}"
      start = plan.max_conversations + 1
      yield plan, range
    end
  end
end
