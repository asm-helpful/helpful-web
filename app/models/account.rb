require 'activerecord/uuid'

class Account < ActiveRecord::Base
  include ActiveRecord::UUID

  has_many :conversations

  has_many :memberships
  has_many :users, through: :memberships

  attr_accessor :new_account_user

  validates :name, presence: true

  after_create :save_new_user

  protected

  def save_new_user
    if new_account_user
      new_account_user.save || raise(ActiveRecord::Rollback)
      Membership.create(account: self, user: new_account_user, role: 'owner') || raise(ActiveRecord::Rollback)
    end
  end
end
