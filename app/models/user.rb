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
end
