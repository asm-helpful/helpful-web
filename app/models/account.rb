require 'activerecord/uuid'

class Account < ActiveRecord::Base
  include ActiveRecord::UUID
  extend FriendlyId

  friendly_id :account_slug, :use => :slugged

  has_many :conversations

  has_many :memberships
  has_many :users, through: :memberships

  attr_accessor :new_account_user

  validates :name, presence: true
  validates :slug, presence: true

  after_create :save_new_user

  # Candidates for how to generate the slug.
  def account_slug
    [:name]
  end

  protected

  def save_new_user
    if new_account_user
      new_account_user.save || raise(ActiveRecord::Rollback)
      Membership.create(account: self, user: new_account_user, role: 'owner') || raise(ActiveRecord::Rollback)
    end
  end
end
