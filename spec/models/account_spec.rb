require 'spec_helper'

describe Account do
  before do
    @account = build(:account)
  end

  it "must be valid" do
    expect(@account).to be_valid
  end

  it "must have a unique slug" do
    Account.create name: 'unique', slug: 'unique'
    @account.name = 'unique'
    @account.slug = 'unique'

    expect { @account.save }.to raise_error(ActiveRecord::RecordNotUnique)
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
end
