require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  STATUS_ARCHIVED = 'archived'

  belongs_to :account
  has_many :messages

  sequential column: :number, scope: :account_id

  default_scope -> { order(:updated_at => :asc) }

  scope :open, -> { where.not(status: STATUS_ARCHIVED) }
  scope :archived, -> { where(status: STATUS_ARCHIVED) }

  def ordered_messages
    messages.order(:created_at => :asc)
  end

  def participant_emails
    participants.map {|person| person.email }.uniq
  end

  def participants
    messages.map {|message| message.person }.uniq
  end

  def archived?
    status == STATUS_ARCHIVED
  end

  def archive
    update_attribute(:status, STATUS_ARCHIVED)
  end

end
