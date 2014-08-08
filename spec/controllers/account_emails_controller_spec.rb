require 'spec_helper'

describe AccountEmailsController do
  context 'slug does not exist' do
    before do
      get :show, id: 'test'
    end

    it 'returns not found' do
      expect(response.status).to eq(404)
    end
  end

  context 'slug already exists' do
    before do
      create(:account, :name => 'test')
      get :show, id: 'test'
    end

    it 'returns success' do
      expect(response).to be_successful
    end

    it 'returns the "is not unique" error as json' do
      expect(response.body).to eq '{"account_emails":["is not unique"]}'
    end
  end
end
