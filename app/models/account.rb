require 'activerecord/uuid'

class Account < ActiveRecord::Base
  include ActiveRecord::UUID
end
