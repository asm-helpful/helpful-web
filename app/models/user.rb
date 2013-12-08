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

  has_one :person

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner
end
