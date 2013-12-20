require 'activerecord/uuid'

class Person < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :user
  belongs_to :account
  has_many :messages
  has_many :read_receipts

  validates :email,
    allow_blank: true,
    format: /\A[^@]+@[^@]+\z/,
    uniqueness: {:scope => :account}

  validates :twitter,
    allow_blank: true,
    uniqueness: {:scope => :account}

  delegate :agent_or_higher?, to: :user, allow_nil: true

end
