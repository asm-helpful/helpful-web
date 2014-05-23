require 'spec_helper'

describe UsersController do
  let!(:user) { create(:user_with_account, email: 'patrick.spec@assemblymade.com') }
  let!(:person) { create(:person, user: user, name: 'Patrick McGrath', email: 'patrick.spec@assemblymade.com', username: 'jimmy', account_id: user.accounts.first.id) }

  before { sign_in(user) }

  describe '#update' do
    it 'updates the current users personal settings' do
      put :update, {
        id: user.id,
        user: {
          name: 'Jimmy Hoffa',
          email: 'jimmy@helpful.io'
        },
        person: {
          username: 'jimmy2',
          avatar: fixture_file_upload("spongebob.gif", 'image/gif')
        }
      }

      user.reload

      expect(response).to redirect_to(edit_user_path)

      expect(user.email).to eq('jimmy@helpful.io')
      expect(user.person.email).to eq('jimmy@helpful.io')
      expect(user.person.name).to eq('Jimmy Hoffa')
      expect(user.username).to eq('jimmy2')
      expect(user.person.avatar.file).to_not be_nil
    end

    context "when trying to choose a username that already exists" do
      let!(:user2) { create(:user, email: 'user2@assemblymade.com') }
      let!(:membership2) { create(:membership, user: user2, account: user.accounts.first) }
      let!(:person2) { create(:person, user: user2, username: 'elvis', name: 'Patrick', email: 'user2@assemblymade.com', account_id: user.accounts.first.id) }

      it 'the test users should have belong to the same account' do
        expect(user.person.account_id).to eq user2.person.account_id
      end

      it 'returns an error message when submitted' do
        put :update, {
          user: {
            name: 'Pat',
            email: 'user@user.com'
          },
          id: user.id,
          person: {
            username: 'elvis'
          }
        }

        expect(response).to be_success
      end
    end
  end
end
