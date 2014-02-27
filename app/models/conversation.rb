require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  # Internal: Regex to extract account slug and conversation number from
  # Conversation#mailbox addresses.
  MAILBOX_REGEX = Regexp.new(
                    /^(?<slug>(\w|-)+)(\+\S+)?\+(?<number>\d+)?@.+$/
                  ).freeze

  belongs_to :account

  has_many :messages, after_add: :message_added_callback,
                      dependent: :destroy

  has_many :notes, dependent: :destroy
  has_many :participants, -> { uniq }, through: :messages,
                                       source: :person

  validates :account, presence: true

  scope :archived, -> { where(archived: true) }
  scope :most_stale, -> { joins(:messages).order('messages.updated_at ASC') }

  sequential column: :number, scope: :account_id

  def mailing_list
    participants + account.users.map {|u| u.person }
  end

  def ordered_messages
    messages.order(:created_at => :asc)
  end

  def archive!
    update_attribute(:archived, true)
  end

  def unarchive!
    update_attribute(:archived, false)
  end


  # Public: Conversation specific email address for incoming email replies.
  #
  # Returns the Mail::Address customers should send email replies to.
  def mailbox
    email = Mail::Address.new([
      account.slug,
      "+#{number}",
      '@',
      Helpful.incoming_email_domain
    ].join.to_s)

    email.display_name = account.name

    email
  end

  # Public: Given an email address try to match to a conversation.
  #
  # Returns a Conversation or nil.
  def self.match_mailbox(email)
    address = Mail::Address.new(email).address

    match = MAILBOX_REGEX.match(address)
    if match
      account = Account.where(slug: match[:slug]).first
      return Conversation.where(account: account, number: match[:number]).first
    else
      return nil
    end
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

private

  def message_added_callback(message)
    unarchive!
  end

end
