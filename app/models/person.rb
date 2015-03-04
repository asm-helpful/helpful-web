require 'activerecord/uuid'

class Person < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :user
  belongs_to :account
  has_many :memberships, through: :user
  has_many :messages
  has_many :read_receipts

  validates :email,
    allow_blank: true,
    email: true,
    uniqueness: { :scope => :account}

  validates :name,
    presence: true,
    if: ->(p) { p.user.present? }

  validates :username,
    allow_blank: true,
    uniqueness: {:scope => :account}

  validates :twitter,
    allow_blank: true,
    twitter: true,
    uniqueness: {:scope => :account}

  before_validation :parse_email, if: :email_changed?

  mount_uploader :avatar, AvatarUploader

  def member?(account)
    memberships.where(account_id: account.id).exists?
  end

  Membership::ROLES.each do |role_name|
    define_method("account_#{role_name}?") do |account|
      account_member_role?(account, role_name)
    end
  end

  def self.find_or_create_by_addr(addr)
    find_by(email: addr.address) || initialize_by_addr(addr)
  end

  def self.initialize_by_addr(addr)
    new(
      email: addr.address,
      name:  addr.display_name
    )
  end

  def account_member_role?(account, role)
    memberships.where(account_id: account.id, role: role).exists?
  end

  # Returns the initial(s) for this person (used in avatars)
  def initials
    if name.present?
      name.to_s.split(' ', 2).map(&:first).join
    else
      email.to_s.first
    end
  end

  def email_address
    addr = Mail::Address.new(email)
    addr.display_name = name
    addr
  end

  def notify?
    # Can't inverse the logic of this — #never_notify? isn't binary
    !agent? || !user.never_notify?
  end

  def agent?
    user.present?
  end

  private

  # Private: Make sure we only save the address portion of an email address.
  #
  # Returns nothing.
  def parse_email
    mail = Mail::Address.new(self.email.to_ascii)
    self.email = mail.address
  end

end
