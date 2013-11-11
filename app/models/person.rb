require 'activerecord/uuid'

class Person < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :user
  has_many :messages

  validates :email, allow_blank: true, format: /\A[^@]+@[^@]+\z/
end
