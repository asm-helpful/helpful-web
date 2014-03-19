require 'spec_helper'

describe Conversation do

  subject { build(:conversation) }

  let(:message) { build(:message) }

  it "is valid" do
    expect(subject).to be_valid
  end

  it "is not archived" do
    expect(subject).to_not be_archived
  end

  it "is reopened when new messages are added" do
    subject.archived = true
    subject.messages << message
    expect(subject).to_not be_archived
  end

  describe "#unarchive!" do
    before do 
      subject.save
      subject.unarchive!
    end
    
    it "archives the conversation" do
      expect(subject).to_not be_archived
    end

    it "sets the flash notice" do
      expect(subject.flash_notice).to eq("The conversation has been moved to the inbox.")
    end
  end

  describe "#archive!" do
    before do 
      subject.save
      subject.archive!
    end
    
    it "archives the conversation" do
      expect(subject).to be_archived
    end

    it "sets the flash notice" do
      expect(subject.flash_notice).to eq("The conversation has been archived.")
    end
  end

  describe "#respond_later!" do
    let!(:user) { create(:user) }

    before { subject.save }

    it "creates a respond later record" do
      subject.respond_later!(user)

      expect(subject.respond_laters).not_to be_empty
    end
  end

  describe "#mailbox_email" do
    before { subject.save }
    
    it "must return a valid email" do
      expect(subject.mailbox_email.address).to_not be_empty
    end

    it "must have the correct local part" do
      subject.save
      expect(subject.mailbox_email.local).to eq(subject.id)
    end

    it "must have the correct domain part" do
      subject.save
      expect(subject.mailbox_email.domain).to eq(Helpful.incoming_email_domain)
    end

    it "must have the correct display name" do
      subject.save
      expect(subject.mailbox_email.display_name).to eq(subject.account.name)
    end
  end

  describe ".match_mailbox" do

    it "matches a mailbox email to a conversation" do
      subject.save
      expect(described_class.match_mailbox(subject.mailbox_email.to_s)).to eq(subject)
    end

    it "raises an exception if a converstion is not found" do
      subject.save
      address = subject.mailbox_email.to_s
      subject.delete
      expect {
        described_class.match_mailbox!(address)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#most_recent_message" do
    it "returns the most recently updated message" do
      subject.save
      _old_message = create(:message, conversation: subject, updated_at: 10.minutes.ago)
      new_message = create(:message, conversation: subject, updated_at: 1.minute.ago)

      expect(subject.most_recent_message).to eq(new_message)
    end
  end

  describe "#to_mailbox_hash" do

    before { subject.save }

    it "returns a hash containing the account_slug and the conversation_id" do
      expect(subject.to_mailbox_hash).to include(
        { account_slug: subject.account.slug }, 
        { conversation_number: subject.number }
      )
    end
  end

end
