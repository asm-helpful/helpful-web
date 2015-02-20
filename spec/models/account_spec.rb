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

end
