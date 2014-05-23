require 'activerecord/uuid'

class User < ActiveRecord::Base
  include ActiveRecord::UUID

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

  def avatar
    self.try(:person).try(:avatar)
  end
end
