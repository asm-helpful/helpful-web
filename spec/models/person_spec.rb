require "spec_helper"

describe Person do
  let(:person) { Person.new }

  it "must be valid" do
    expect(person).to be_valid
  end

  context "when using a username" do
    let(:person2){ create(:person) }
    it 'must have a unique username per account' do
      person.username = person2.username
      expect(person).to be_invalid
    end
  end
  

  describe "Person#parse_email" do

    it "handles email addresses without display names" do
      email = "jsmith@example.com"
      person.email = email
      person.save

      expect(person.email).to eq(email)
    end

    it "parses out the email address from email" do
      person.email = "John Smith <jsmith@example.com>"
      person.save

      expect(person.email).to eq('jsmith@example.com')
    end

    it "parses out the email address from email even with extended characters" do
      person.email = "Nícolas Iensen <nicolas@example.com>"
      person.save

      expect(person.email).to eq('nicolas@example.com')
    end
  end

  context 'with memberships' do
    let!(:user) { create(:user) }
    let!(:person) { create(:person, user: user) }
    let!(:account) { create(:account) }
    let!(:membership) { create(:membership, account: account, user: user) }

    describe "role helpers for account membership" do
      it "returns true if the membership has the matching role for the given account" do
        membership.update(role: 'owner')
        expect(person).to be_account_owner(account)

        membership.update(role: 'agent')
        expect(person).to be_account_agent(account)
      end
    end

    describe "account membership" do
      it "returns true if the person is a member of the given account" do
        expect(person).to be_member(account)
      end
    end
  end
end
