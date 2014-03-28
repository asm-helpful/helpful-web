require 'spec_helper'

describe UsersController do
  let!(:user) { create(:user_with_account, email: 'patrick@assemblymade.com') }
  let!(:person) { create(:person, user: user, name: 'Patrick', email: 'patrick@assemblymade.com') }

  before { sign_in(user) }

  describe '#update' do
    it 'updates the current users personal settings' do
      put :update, {
        id: user.id,
        user: {
          person_attributes: {
            name: 'Jimmy Hoffa',
            email: 'jimmy@helpful.io'
          }
        }
      }

      user.reload

      expect(user.email).to eq('jimmy@helpful.io')
      expect(user.person.email).to eq('jimmy@helpful.io')
      expect(user.person.name).to eq('Jimmy Hoffa')
    end
  end
end
