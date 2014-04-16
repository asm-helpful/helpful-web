require 'activerecord/uuid'

class User < ActiveRecord::Base
  include ActiveRecord::UUID

  # Include default devise modules. Others available are:
  # :rememberable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable,
         :lockable, :timeoutable

  has_many :memberships
  has_many :accounts, through: :memberships
  has_many :conversations

  has_many :owner_memberships, -> { where(role: 'owner') }, class_name: 'Membership'
  has_many :owned_accounts, class_name: 'Account', through: :owner_memberships, source: :account

  has_one :person

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  delegate :username,
    to: :person,
    allow_nil: true

  delegate :name,
    to: :person,
    allow_nil: true

  delegate :initials,
    to: :person,
    allow_nil: true

  accepts_nested_attributes_for :person

  # Returns the first owned account
  # Later we need to better support a user who owns multiple accounts (or is a member of multiple accounts)
  # But for now let's just assume there is either zero or one
  def primary_owned_account
    self.owned_accounts.first
  end

end
