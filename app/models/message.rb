require 'activerecord/uuid'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :conversation, touch: true
end
