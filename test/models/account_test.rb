require 'test_helper'

describe Account do
  before do
    @account = build(:account)
  end

  it "must be valid" do
    @account.valid?.must_equal true
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
      refute @account.mailbox.address.empty?
    end

    it "must have the correct local part" do
      @account.save
      assert_equal @account.slug, @account.mailbox.local
    end

    it "must have the correct domain part" do
      @account.save
      assert_equal Supportly.incoming_email_domain, @account.mailbox.domain
    end

    it "must have the correct display_name" do
      @account.save
      assert_equal @account.name, @account.mailbox.display_name
    end
  end

  describe ".match_mailbox" do

    it "matches a mailbox email to an account" do
      @account.save
      assert_equal @account, Account.match_mailbox(@account.mailbox.to_s)
    end
  end

  describe ".match_mailbox!" do

    it "matches a mailbox email to an account" do
      @account.save
      assert_equal @account, Account.match_mailbox(@account.mailbox.to_s)
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
