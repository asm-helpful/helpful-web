require 'spec_helper'

describe TextcompleteSearch do
  let(:account) { double('Account') }

  describe '#results' do
    let!(:account) { create(:account) }
    let!(:canned_response) { create(:canned_response, account: account, key: 'refund') }

    it 'grabs matching objects for the query type' do
      search = TextcompleteSearch.new(account, 'ref', 'canned_responses')
      expect(search.results.first.fetch(:value)).to eq('refund')
    end

    it 'returns an empty array if the query is empty' do
      search = TextcompleteSearch.new(account, '', 'tags')
      expect(search.results).to eq([])
    end
  end
end
