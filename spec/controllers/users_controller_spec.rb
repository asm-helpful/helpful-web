require 'spec_helper'

describe UsersController do
  let!(:user) { create(:user_with_account, email: 'patrick.spec@assemblymade.com') }
  let!(:person) { create(:person, user: user, name: 'Patrick McGrath', email: 'patrick.spec@assemblymade.com', username: 'jimmy', account_id: user.accounts.first.id) }

  before { sign_in(user) }

  describe '#update' do
    it 'updates the current users personal settings' do
      put :update, {
        id: user.id,
        person: {
          name: 'Jimmy Hoffa',
          email: 'jimmy@helpful.io',
          avatar: fixture_file_upload("spongebob.gif", 'image/gif')
        },
        user: {
          notification_setting: 'never'
        }
      }

      user.reload

      expect(response).to redirect_to(edit_user_path)

      expect(user.email).to eq('jimmy@helpful.io')
      expect(user.person.email).to eq('jimmy@helpful.io')
      expect(user.person.name).to eq('Jimmy Hoffa')
      expect(user.person.avatar.file).to_not be_nil
    end
  end
end
