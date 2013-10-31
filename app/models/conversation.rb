require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID
end
