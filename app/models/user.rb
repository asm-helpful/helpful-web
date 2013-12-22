require 'activerecord/uuid'

class User < ActiveRecord::Base
  include ActiveRecord::UUID

  # Include default devise modules. Others available are:
  # :rememberable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :memberships
  has_many :accounts, through: :memberships

  has_many :owner_memberships, -> { where(role: 'owner') }, class_name: 'Membership'
  has_many :owned_accounts, class_name: 'Account', through: :owner_memberships, source: :account

  has_one :person

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  # Returns the first owned account
  # Later we need to better support a user who owns multiple accounts (or is a member of multiple accounts)
  # But for now let's just assume there is either zero or one
  def primary_owned_account
    self.owned_accounts.first
  end

  def agent_or_higher?(account_id)
    r = memberships.where(account_id: account_id).first.try(:role)
    !!(r == 'agent' || r == 'owner')
  end

end
