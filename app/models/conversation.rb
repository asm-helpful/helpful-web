require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :account

  belongs_to :user

  has_many :account_people,
    through: :account,
    source: :user_people

  has_many :messages,
    after_add: :message_added_callback,
    dependent: :destroy

  has_many :participants,
    -> { uniq },
    through: :messages,
    source: :person

  has_many :respond_laters

  validates :account, presence: true

  default_scope -> { where(hidden: false) }

  scope :unresolved, -> { where(archived: false) }

  scope :archived, -> { where(archived: true) }

  scope :most_recent, -> { order('updated_at DESC') }

  scope :queue, -> { order('updated_at ASC') }

  scope :this_month, -> { where('extract(month from created_at) = ? and extract(year from created_at) = ?', Time.now.month, Time.now.year) }

  sequential column: :number,
    scope: :account_id

  before_create :check_conversations_limit

  after_commit :notify_account_people,
    on: :create

  def archive!
    update(archived: true)
  end

  def unarchive!
    update(archived: false)
  end

  def respond_later!(user)
    respond_later = respond_laters.find_or_create_by(user: user)
    respond_later.touch
  end

  def just_archived?
    _, new_archived = previous_changes[:archived]
    !!new_archived
  end

  def just_unarchived?
    _, new_archived = previous_changes[:archived]
    new_archived == false
  end

  def creator_person
    first_message.person
  end

  def first_message
    messages.order('created_at ASC').first
  end

  def subsequent_messages
    messages.order('created_at ASC').offset(1)
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

  def last_activity_at
    if most_recent_message
      most_recent_message.updated_at
    else
      updated_at
    end
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

  def notify_account_people
    return unless most_recent_message
    return if unpaid?
    MessageMailman.deliver(most_recent_message, account_people)
  end

  def unpaid?
    hidden
  end

  private

  def message_added_callback(message)
    unarchive!
  end

  def check_conversations_limit
    self.hidden = true if self.account.conversations_limit_reached?
  end
end
