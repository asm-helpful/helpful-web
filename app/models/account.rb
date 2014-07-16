require 'activerecord/uuid'

class Account < ActiveRecord::Base
  include ActiveRecord::UUID
  extend FriendlyId

  attr_accessor :stripe_token, :billing_plan_slug

  belongs_to :billing_plan

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

  validates :billing_plan,
    presence: true

  before_create :generate_webhook_secret
  before_create :set_default_billing_plan
  before_save :subscribe!
  after_commit :unhide_paid_conversations

  friendly_id :name, use: :slugged

  # Internal: Regex to extract an account slug from a Account#mailbox address
  MAILBOX_REGEX = Regexp.new(/^(?<slug>(\w|-)+)(\+\w+)?@.+$/).freeze

  # Public: Customer specific email address for incoming email.
  #
  # Returns the email address customers should send email to.
  def mailbox_email
    email = Mail::Address.new([
      slug,
      '@',
      Helpful.incoming_email_domain
    ].join.to_s)

    email.display_name = name

    email
  end

  # Overrides the portal url attribute to regenerate every few days with a newly valid link
  def chargify_portal_url

    if self[:chargify_portal_url].blank? || chargify_portal_valid_until < Time.zone.now
      if self.chargify_customer_id.to_i > 0 # In dev it's possibly we 'faked' it.  If so, we don't want to hit Chargify with an invalid request

        new_url, expiration = Chargify.management_url(self.chargify_customer_id)
        if new_url
          self.update_attributes({chargify_portal_url: new_url, chargify_portal_valid_until: expiration})
        end

      end
    end

    self[:chargify_portal_url] || ''
  end

  # Retrieves the latest subscription info and saves it to the account
  def get_update_from_chargify!
    self.chargify_subscription_id ||= Chargify.subscription_id_from_customer_reference(self.id)

    if chargify_subscription_id
      r = Chargify.subscription_status(chargify_subscription_id)

      if r
        self.billing_status = r['subscription']['state']
        self.billing_plan   = BillingPlan.find_by_slug r['subscription']['product']['handle']
        self.chargify_customer_id = r['subscription']['customer']['id']

        self.save!
      end
    end
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

  def conversations_limit
    return self.billing_plan.max_conversations
  end

  def conversations_limit_reached?
    return self.conversations.this_month.size >= self.conversations_limit
  end

  def billing_plan_slug
    billing_plan && billing_plan.slug
  end

  def billing_plan_slug=(new_billing_plan_slug)
    self.billing_plan = BillingPlan.find_by(slug: new_billing_plan_slug)
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
    return if !self.billing_plan_id_changed? || (self.stripe_customer_id.blank? && self.billing_plan.free?)

    if self.stripe_customer_id.blank?
      # first time subscriber
      customer = Stripe::Customer.create(
        card: stripe_token,
        plan: self.billing_plan.slug,
        email: owner && owner.email
      )

      self.stripe_customer_id = customer.id
    else
      # already had a subscription before
      customer = Stripe::Customer.retrieve(self.stripe_customer_id)

      if self.billing_plan.free?
        # new subscription is free so cancel
        customer.cancel_subscription
      else
        customer.update_subscription(plan: billing_plan.slug)
      end
    end
  end

  def unhide_paid_conversations
    ActiveRecord::Base.transaction do
      paid_count = conversations.paid.count
      unhide_count = conversations_limit - paid_count

      conversations.unpaid.
        order('created_at ASC').
        limit(unhide_count).
        update_all(hidden: false)
    end
  end

  def tags
    conversations.including_unpaid.pluck(:tags).flatten.uniq.sort
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

  protected

  def generate_webhook_secret
    self.webhook_secret ||= SecureRandom.hex(16)
  end

  def set_default_billing_plan
    self.billing_plan ||= BillingPlan.find_by_slug('starter-kit')
  end

end
