require 'activerecord/uuid'

class BillingPlan < ActiveRecord::Base
  include ActiveRecord::UUID

  has_many :accounts

  scope :ordered, -> { order(price: :asc) }
end
