require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  STATUS_ARCHIVED = 'archived'
  STATUS_OPEN = 'open'

  belongs_to :account
  has_many :messages,
    :after_add => :new_message,
    :dependent => :destroy

  sequential column: :number, scope: :account_id

  validates :account, presence: true

  default_scope -> { order(:updated_at => :asc) }

  scope :open, -> { where.not(status: STATUS_ARCHIVED) }
  scope :archived, -> { where(status: STATUS_ARCHIVED) }

  def ordered_messages
    messages.order(:created_at => :asc)
  end

  def participants
    messages.collect(&:person).uniq
  end

  def archived?
    status == STATUS_ARCHIVED
  end

  def archive
    update_attribute(:status, STATUS_ARCHIVED)
  end

  def un_archive
    update_attribute(:status, STATUS_OPEN)
  end

  def archive=(flag)
    if flag
      archive
    else
      un_archive
    end
  end

  def new_message(message)
    update_attribute(:status, STATUS_OPEN)
    if messages.count == 1
      ConversationMailer.new_conversation(id, message.person.id).deliver
    else
      (participants - [message.person]).each do |person|
        ConversationMailer.new_reply(id, person.id).deliver
      end
    end
  end

  def to_param
    number.to_param
  end

end
