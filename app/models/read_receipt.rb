require 'activerecord/uuid'

class ReadReceipt < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :message
  belongs_to :person
end
