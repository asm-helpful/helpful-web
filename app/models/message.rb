require 'activerecord/uuid'
require 'elasticsearch'

class Message < ActiveRecord::Base
  include ActiveRecord::UUID

  before_create :populate_person
  belongs_to :conversation, touch: true
  belongs_to :person

  delegate :account, :to => :conversation

  def populate_person
    if person_id.blank?
      person = Person.find_or_create_by!(email: from.to_s.strip)
      self.person_id = person.id
    end
  end

end
