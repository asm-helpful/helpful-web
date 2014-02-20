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

    assert_raises(ActiveRecord::RecordNotUnique) do
      @account.save
    end
  end

  it "must have a webhook_url field" do
    assert Account.column_names.include?("webhook_url")
  end

  describe "#mailbox" do

    it "must return a valid email" do
      @account.save
      expect(@account.mailbox.address).to_not be_empty
    end

    it "must have the correct local part" do
      @account.save
      expect(@account.mailbox.local).to eq(@account.slug)
    end

    it "must have the correct domain part" do
      @account.save
      expect(@account.mailbox.domain).to eq(Helpful.incoming_email_domain)
    end

    it "must have the correct display_name" do
      @account.save
      expect(@account.mailbox.display_name).to eq(@account.name)
    end
  end

  describe ".match_mailbox" do

    it "matches a mailbox email to an account" do
      @account.save
      expect(Account.match_mailbox(@account.mailbox.to_s)).to eq(@account)
    end

  end

  describe ".match_mailbox!" do

    it "matches a mailbox email to an account" do
      @account.save
      expect(Account.match_mailbox(@account.mailbox.to_s)).to eq(@account)
    end

    it "raises an exception if an account is not found" do
      @account.save
      address = @account.mailbox.to_s
      @account.delete
      assert_raise ActiveRecord::RecordNotFound do
        Account.match_mailbox!(address)
      end
    end
  end
end
