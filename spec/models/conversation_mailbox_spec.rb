require 'spec_helper'

describe ConversationMailbox do

  subject { build(:conversation_mailbox, id: 'SHA') }

  describe "#address" do
    it "should be a Mail::Address object" do
      expect(subject.address).to be_a(Mail::Address)
    end
    
    it "returns an email address using the mailbox id" do
      expect(subject.address.to_s).to eq("SHA@#{Helpful.incoming_email_domain}")
    end
  end

  describe "#to_h" do

    before { subject.save }

    it "returns a hash containing the account_slug and the conversation_id" do
      expect(subject.to_h).to include(
        { account_slug: subject.account.slug }, 
        { conversation_number: subject.conversation.number }
      )
    end
  end
end