require 'spec_helper'

describe Account do
  let(:account) { FactoryGirl.build(:account) }

  it 'is valid' do
    expect(account).to be_valid
  end

  it 'has unique slug' do
    FactoryGirl.create(:account, name: 'unique', slug: 'unique')
    account.name = 'unique'
    account.slug = 'unique'

    expect(account).to be_invalid
  end

  describe '#mailbox_email' do
    it 'must return a valid email' do
      account.save
      expect(account.mailbox_email.address).to_not be_empty
    end

    it 'has the correct local part' do
      account.save
      expect(account.mailbox_email.local).to eq(account.slug)
    end

    it 'has the correct domain part' do
      account.save
      expect(account.mailbox_email.domain).to eq(Helpful.incoming_email_domain)
    end

    it 'has the correct display name' do
      account.save
      expect(account.mailbox_email.display_name).to eq(account.name)
    end
  end

  describe '.conversations_limit_reached?' do
    before do
      account.save
      account.stub(conversations_limit: 2)
    end

    it 'knows when the limit has not been reached' do
      account.conversations << FactoryGirl.build(:conversation)

      expect(account.conversations_limit_reached?).to eq(false)
    end

    it 'knows when the limit is reached' do
      2.times { account.conversations << FactoryGirl.build(:conversation) }

      expect(account.conversations_limit_reached?).to eq(true)
    end

    it 'marks conversations after the limit is reached as unpaid' do
      3.times { account.conversations << FactoryGirl.build(:conversation) }

      last_conversation = account.conversations.including_unpaid.most_recent.first

      expect(last_conversation).to be_unpaid
    end

    it 'removes conversations over the limit from any scopes' do
      3.times { account.conversations << FactoryGirl.build(:conversation) }

      expect(account.conversations.size).to eq(2)
    end
  end

  describe '#unhide_paid_conversations' do
    it 'checks for hidden conversations and toggles them if the limit has been increased' do
      account.billing_plan = create(:billing_plan, max_conversations: 1) 
      account.save

      2.times do
        account.conversations << build(:conversation)
      end

      account.reload

      account.billing_plan = create(:billing_plan, max_conversations: 2)
      account.save

      expect(account.conversations.paid.count).to eq(2)
    end
  end

end
