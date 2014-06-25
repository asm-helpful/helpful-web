require 'activerecord/uuid'

class Conversation < ActiveRecord::Base
  include ActiveRecord::UUID

  belongs_to :account

  belongs_to :user

  has_many :account_people,
    through: :account,
    source: :user_people

  has_many :messages,
    -> { order('created_at ASC') },
    after_add: :message_added_callback,
    dependent: :destroy

  has_one :first_message,
    -> { order('messages.updated_at ASC').limit(1) },
    class_name: 'Message'

  has_many :subsequent_messages,
    -> { order('messages.updated_at ASC').offset(1) },
    class_name: 'Message'

  has_one :most_recent_message,
    -> { order('messages.updated_at DESC').limit(1) },
    class_name: 'Message'

  has_many :participants,
    -> { uniq },
    through: :messages,
    source: :person

  has_many :read_receipts,
    through: :messages

  has_many :respond_laters

  has_many :assignment_events

  has_many :tag_events

  validates :account, presence: true

  default_scope -> { paid }

  scope :archived, -> { where(archived: true) }

  scope :assigned_to, -> (user) { where(user_id: user.id) }

  scope :unassigned_or_assigned_to, -> (user) { where(user_id: [nil, user.id]) }

  scope :most_recent, -> { order('updated_at DESC') }

  scope :queue, -> { order('updated_at ASC') }

  scope :paid, -> { where(hidden: false) }

  scope :unpaid, -> { including_unpaid.where(hidden: true) }

  scope :including_unpaid, -> { unscope(where: :hidden) }

  scope :this_month, -> { where("DATE_TRUNC('month', created_at) = ?", Time.now.utc.beginning_of_month) }

  scope :unresolved, -> { where(archived: false) }

  scope :with_messages_count, -> { select('conversations.*, (SELECT COUNT(messages.id) FROM messages WHERE messages.conversation_id = conversations.id) AS messages_count') }

  scope :welcome_email, -> { where(subject: WelcomeConversation::SUBJECT) }

  scope :with_messages, -> { where('(SELECT COUNT(messages.id) FROM messages WHERE messages.conversation_id = conversations.id) > 0') }

  sequential column: :number,
    scope: :account_id

  before_create :check_conversations_limit

  after_commit :notify_account_people,
    on: :create

  def self.queue_order(user)
    self.joins("LEFT OUTER JOIN respond_laters ON conversations.id = respond_laters.conversation_id AND respond_laters.user_id = '#{user.id}'").
      order('respond_laters.updated_at ASC NULLS FIRST').
      order('conversations.updated_at DESC')
  end

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
    first_message && first_message.person
  end

  def messages_count
    self['messages_count'] || messages.count
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
    return if messages.empty? || unpaid?
    MessageMailman.deliver(most_recent_message, account_people)
  end

  def unpaid?
    hidden
  end

  def stale?
    !archived? && last_activity_at < 3.days.ago
  end

  def subject
    super.presence || first_message && first_message.content.to_s[0..140]
  end

  private

  def message_added_callback(message)
    unarchive!
  end

  def check_conversations_limit
    self.hidden = true if account.conversations_limit_reached?
  end
end
