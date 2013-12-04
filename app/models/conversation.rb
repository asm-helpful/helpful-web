require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  STATUS_ARCHIVED = 'archived'
  STATUS_OPEN = 'open'

  belongs_to :account
  has_many :messages,
    :after_add => :open_with_new_message,
    :dependent => :destroy

  sequential column: :number, scope: :account_id

  validates :account, presence: true

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

  def open_with_new_message(message)
    update_attribute(:status, STATUS_OPEN)
  end

  def to_param
    number.to_param
  end

end
