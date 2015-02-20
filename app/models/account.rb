require 'activerecord/uuid'

class Account < ActiveRecord::Base
  include ActiveRecord::UUID

  PRO_PLAN_ID = 'pro-30'

  attr_accessor :stripe_token

  has_many :canned_responses,
    dependent: :destroy

  has_many :conversations,
    dependent: :destroy

  has_many :messages,
    through: :conversations

  has_many :people,
    dependent: :destroy

  has_many :memberships,
    dependent: :destroy

  has_many :users,
    through: :memberships

  has_many :user_people,
    through: :users,
    source: :person

  has_many :webhooks,
    dependent: :destroy

  validates :name,
    presence: true,
    uniqueness: true

  validate :email_presence
  validate :email_uniqueness

  before_create :generate_webhook_secret
  before_save :subscribe!
  before_validation :generate_slug

  MAILBOX_REGEX = Regexp.new(/^(?<slug>(\w|-)+)(\+\w+)?@.+$/).freeze

  def email=(new_email)
    address = Mail::Address.new(new_email).address
    matches = MAILBOX_REGEX.match(address)
    self.slug = matches && matches[:slug]
  end

  def email
    mailbox_email && mailbox_email.address
  end

  def mailbox_email
    return unless slug.present?

    email = Mail::Address.new([
      slug,
      '@',
      Helpful.incoming_email_domain
    ].join.to_s)

    email.display_name = name

    email
  end

  def add_owner(owner)
    memberships.create(user: owner, role: 'owner')
  end

  def add_owner!(owner)
    memberships.create(user: owner, role: 'owner') ||
      raise(ActiveRecord::Rollback)
  end

  def add_agent(agent)
    memberships.create(user: agent, role: 'agent')
  end

  def owner
    owner_membership = memberships.where(role: 'owner').first
    owner_membership && owner_membership.user
  end

  def owner?(user)
    memberships.where(user: user, role: 'owner').exists?
  end

  def roles_allowed_by(user)
    if owner?(user)
      ['owner', 'agent']
    else
      ['agent']
    end
  end

  def subscribe!
    return if self.stripe_token.blank?

    # first time subscriber
    customer = Stripe::Customer.create(
      source: stripe_token,
      plan: PRO_PLAN_ID,
      email: owner.email,
      description: name,
      metadata: {
        id: id
      }
    )

    self.stripe_customer_id = customer.id
    self.is_pro = true
  end

  def pro?
    is_pro?
  end

  def free?
    !is_pro?
  end

  def tags
    conversations.pluck(:tags).flatten.uniq.sort
  end

  def inbox_count
    conversations.with_messages.where(archived: false).count
  end

  def archived_count
    conversations.with_messages.where(archived: true).count
  end

  def team
    memberships.select {|m| m.user.accepted_or_not_invited? }
  end

  def invitations
    memberships.reject {|m| m.user.accepted_or_not_invited? }
  end

  def generate_slug
    self.slug ||= ActiveSupport::Inflector.transliterate(name).
      downcase.gsub(/[^\w\ ]+/, '').gsub(/\ +/,'-')
  end

  def email_presence
    errors.add(:email, 'is not present') unless slug.present?
  end

  def email_uniqueness
    conflicting_account = Account.find_by(slug: slug)
    errors.add(:email, 'is not unique') if conflicting_account && conflicting_account != self
  end

  def email_errors
    valid?
    errors[:email]
  end

  def to_param
    slug
  end

  protected

  def generate_webhook_secret
    self.webhook_secret ||= SecureRandom.hex(16)
  end

end
