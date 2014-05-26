require 'spec_helper'

describe Account do
  before do
    @account = build(:account)
  end

  it "must be valid" do
    expect(@account).to be_valid
  end

  it "must have a unique slug" do
    create(:account, name: 'unique', slug: 'unique')
    @account.name = 'unique'
    @account.slug = 'unique'

    expect(@account).to be_invalid
  end

  it "must have a webhook_url field" do
    assert Account.column_names.include?("webhook_url")
  end

  describe "#mailbox_email" do

    it "must return a valid email" do
      @account.save
      expect(@account.mailbox_email.address).to_not be_empty
    end

    it "must have the correct local part" do
      @account.save
      expect(@account.mailbox_email.local).to eq(@account.slug)
    end

    it "must have the correct domain part" do
      @account.save
      expect(@account.mailbox_email.domain).to eq(Helpful.incoming_email_domain)
    end

    it "must have the correct display_name" do
      @account.save
      expect(@account.mailbox_email.display_name).to eq(@account.name)
    end
  end

  describe ".match_mailbox" do

    it "matches a mailbox email to an account" do
      @account.save
      expect(Account.match_mailbox(@account.mailbox_email.to_s)).to eq(@account)
    end

  end

  describe ".match_mailbox!" do

    it "matches a mailbox email to an account" do
      @account.save
      expect(Account.match_mailbox!(@account.mailbox_email.to_s)).to eq(@account)
    end

    it "raises an exception if an account is not found" do
      @account.save
      address = @account.mailbox_email.to_s
      @account.delete
      expect {
        Account.match_mailbox!(address)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe ".conversations_limit" do

    it "must have the right conversation limit for the default plan" do
      @account.save
      expect(@account.conversations_limit).to eq(25)
    end

  end

  describe ".conversations_limit_reached?" do
    
    before do
      @account.save
      24.times do
        @account.conversations << build(:conversation)
      end
    end

    it "must not reach its limit for the first 24 conversations" do
      expect(@account.conversations_limit_reached?).to eq(false)
    end

    it "must reach its limit after 25 conversations" do
      @account.conversations << build(:conversation)
      expect(@account.conversations_limit_reached?).to eq(true)
    end

    it "must mark conversations after the limit is reached as unpaid" do
      2.times do
        @account.conversations << build(:conversation)
      end

      expect(@account.conversations.including_unpaid.most_recent.first.unpaid?).to eq(true)
    end

    it "must remove conversations over the limit from any scopes" do
      2.times do
        @account.conversations << build(:conversation)
      end

      expect(@account.conversations.size).to eq(25)
    end
  end

  describe '#unhide_paid_conversations' do
    it 'checks for hidden conversations and toggles them if the limit has been increased' do
      @account.billing_plan = create(:billing_plan, max_conversations: 1) 
      @account.save

      2.times do
        @account.conversations << build(:conversation)
      end

      @account.reload

      @account.billing_plan = create(:billing_plan, max_conversations: 2)
      @account.save

      expect(@account.conversations.paid.count).to eq(2)
    end
  end

end
