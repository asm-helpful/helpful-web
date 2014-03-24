require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :account
  belongs_to :user

  has_many :messages, after_add: :message_added_callback,
                      dependent: :destroy

  has_many :participants, -> { uniq }, through: :messages,
                                       source: :person

  has_many :respond_laters

  validates :account, presence: true

  scope :unresolved, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :most_stale, -> { joins(:messages).order('messages.updated_at ASC') }
  scope :queue, -> { order('updated_at ASC') }

  sequential column: :number, scope: :account_id

  attr_accessor :flash_notice

  def mailing_list
    participants + account.users.map {|u| u.person }
  end

  def archive!
    update_attribute(:archived, true)
    self.flash_notice = "The conversation has been archived."
  end

  def unarchive!
    update_attribute(:archived, false)
    self.flash_notice = "The conversation has been moved to the inbox."
  end

  def respond_later!(user)
    respond_later = respond_laters.find_or_create_by(user: user)
    respond_later.touch
  end

  # Public: Conversation specific email address for incoming email replies.
  #
  # Returns the Mail::Address customers should send email replies to.
  def mailbox_email
    email = Mail::Address.new("#{self.id}@#{Helpful.incoming_email_domain}")
    email.display_name = account.name
    email
  end

  # Public: Given an email address try to match to a conversation.
  #
  # Returns a Conversation or nil.
  def self.match_mailbox(email)
    address = Mail::Address.new(email)
    Conversation.find_by_id(address.local)
  end

  # Public: Given an email address try to match to a conversation or raise
  # ActiveRecord::RecordNotFound.
  #
  # Returns a Conversation or raises ActiveRecord::RecordNotFound.
  def self.match_mailbox!(email)
    self.match_mailbox(email) || raise(ActiveRecord::RecordNotFound)
  end

  def most_recent_message
    messages.most_recent.first
  end

  def to_param
    number.to_param
  end

  def to_mailbox_hash
    {
      account_slug: self.account.slug,
      conversation_number: self.number
    }
  end

  def contains_message_id?(message_id)
    messages.detect { |message| message.id == message_id }
  end

  private

  def message_added_callback(message)
    unarchive!
  end
end
