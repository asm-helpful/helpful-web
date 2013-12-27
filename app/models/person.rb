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
    format: /\A[^@]+@[^@]+\z/,
    uniqueness: {:scope => :account}

  validates :twitter,
    allow_blank: true,
    uniqueness: {:scope => :account}

  before_save :parse_email

  private

  # Private: Make sure we only save the address portion of an email address.
  #
  # Returns nothing.
  def parse_email
    mail = Mail::Address.new(self.email)
    self.email = mail.address
  end
end
