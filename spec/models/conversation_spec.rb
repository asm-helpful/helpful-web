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

  it "#unarchive!" do
    subject = create(:conversation, archived: true)
    subject.unarchive!
    expect(subject).to_not be_archived
  end

  describe "#mailbox" do

    it "must return a valid email" do
      expect(subject.mailbox.address).to_not be_empty
    end

    it "must have the correct local part" do
      subject.save
      expected = [subject.account.slug, "+", subject.number].join.to_s
      expect(expected).to eq(subject.mailbox.local)
    end

    it "must have the correct domain part" do
      subject.save
      expect(subject.mailbox.domain).to eq(Helpful.incoming_email_domain)
    end

    it "must have the correct display name" do
      subject.save
      expect(subject.mailbox.display_name).to eq(subject.account.name)
    end
  end

  describe ".match_mailbox" do

    it "matches a mailbox email to a conversation" do
      subject.save
      expect(described_class.match_mailbox(subject.mailbox.to_s)).to eq(subject)
    end

    it "raises an exception if a converstion is not found" do
      subject.save
      address = subject.mailbox.to_s
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

end
