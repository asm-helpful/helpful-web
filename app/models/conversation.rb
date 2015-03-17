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

  has_many :assignment_events

  has_many :tag_events

  validates :account, presence: true

  scope :archived, -> { where(archived: true) }

  scope :assigned_to, -> (user) { where(user_id: user.id) }

  scope :unassigned_or_assigned_to, -> (user) { where(user_id: [nil, user.id]) }

  scope :most_recent, -> { order('updated_at DESC') }

  scope :queue, -> { order('updated_at ASC') }

  scope :this_month, -> { where("DATE_TRUNC('month', created_at) = ?", Time.now.utc.beginning_of_month) }

  scope :unresolved, -> { where(archived: false) }

  scope :with_message_count, -> { select('conversations.*, (SELECT COUNT(messages.id) FROM messages WHERE messages.conversation_id = conversations.id) AS message_count') }

  scope :welcome_conversation, -> { where(subject: WelcomeConversation::SUBJECT) }
  scope :widget_conversation,  -> { where(subject: WidgetConversation::SUBJECT) }
  scope :protip_conversation,  -> { where(subject: ProtipConversation::SUBJECT) }

  scope :with_messages, -> { where('(SELECT COUNT(messages.id) FROM messages WHERE messages.conversation_id = conversations.id) > 0') }

  sequential column: :number,
    scope: :account_id

  def archive!
    update(archived: true)
  end

  def unarchive!
    update(archived: false)
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

  def message_count
    self['message_count'] || messages.count
  end

  # Public: Conversation specific email address for incoming email replies.
  #
  # Returns the Mail::Address customers should send email replies to.
  def mailbox_email
    email = Mail::Address.new("#{self.id}@#{Helpful.incoming_email_domain}")
    email.display_name = account.name
    email
  end

  def self.match_mailbox(email)
    address = Mail::Address.new(email)
    Conversation.find_by(id: address.local)
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

  def contains_message_id?(message_id)
    messages.detect { |message| message.id == message_id }
  end

  def stale?
    !archived? && last_activity_at < 3.days.ago
  end

  def participants_with_assignee
    (participants | [user && user.person]).compact
  end

  private

  def message_added_callback(message)
    unarchive!
  end

end
