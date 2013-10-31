require 'activerecord/uuid'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID
end
