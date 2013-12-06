require 'test_helper'

describe Account do
  before do
    ENV['INCOMING_EMAIL_DOMAIN'] = 'example.com'
    @account = FactoryGirl.build(:account)
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
      assert @account.mailbox.include?("@")
    end

    it "must have the correct local part" do
      @account.save
      assert_equal @account.slug, @account.mailbox.split("@")[0]
    end

    it "must have the correct local part with conversation number" do
      @account.save
      address = @account.mailbox("123")
      assert_equal @account.slug+"+123", address.split("@")[0]
    end

    it "must have the correct domain part" do
      @account.save
      assert_equal ENV['INCOMING_EMAIL_DOMAIN'], @account.mailbox.split("@")[1]
    end
  end

  describe ".match_mailbox" do

    it "matches a mailbox email to an account" do
      @account.save
      assert_equal @account, Account.match_mailbox(@account.mailbox)
    end
  end
end
