require 'activerecord/uuid'

class BillingPlan < ActiveRecord::Base
  include ActiveRecord::UUID

  has_many :accounts
end
