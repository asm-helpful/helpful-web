require 'activerecord/uuid'

class Membership < ActiveRecord::Base
  include ActiveRecord::UUID

  ROLES = ['owner', 'agent']

  belongs_to :account

  belongs_to :user

  validates :account,
    presence: true

  validates :user,
    presence: true,
    uniqueness: { scope: :account_id }

  validates :role,
    inclusion: ROLES

  ROLES.each do |role_name|
    define_method("#{role_name}?") do
      role == role_name
    end
  end
end
