require 'activerecord/uuid'

class Account < ActiveRecord::Base
  include ActiveRecord::UUID

  has_many :conversations
end
