require 'activerecord/uuid'

class Membership < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :account
  belongs_to :user

  validates :account, presence: true
  validates :user, presence: true
  validates :role, inclusion: ['owner', 'support', 'customer']
end
