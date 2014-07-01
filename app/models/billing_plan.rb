require 'activerecord/uuid'

class BillingPlan < ActiveRecord::Base
  include ActiveRecord::UUID

  has_many :accounts

  scope :ordered, -> { order(price: :asc) }

  scope :visible, -> { where(hidden: false) }

  def formatted_price
    (price * 100).to_i.to_s
  end

  def free?
    price.zero?
  end
end
