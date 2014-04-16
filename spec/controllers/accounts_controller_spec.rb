require "spec_helper"

describe AccountsController do

  let(:owner) { create(:user) }
  let(:account) { create(:account) }

  before do
    create(:membership, account: account, user: owner, role: 'owner')
  end


  describe "GET #new" do
    it "is successful" do
      get :new
      expect(response).to be_successful
    end
  end

  it "POST create" do
    post :create, {
      account: {
        name: 'MyCompany'
      },
      person: {
        name: 'John Doe',
        username: 'john'
      },
      user: {
        email: 'user@user.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }

    assert_redirected_to inbox_account_conversations_path('mycompany')
    expect(assigns(:person).username).to eq "john"
  end

  describe "GET #show" do
    it "redirects to the inbox" do
      sign_in(owner)
      get :show, id: account.slug
      expect(response).to redirect_to(inbox_account_conversations_path(account))
    end
  end

  describe "GET #edit" do
    it "requires authentication" do
      get :edit, id: account.slug
      # FIXME: Extract into custom matcher
      expect(request.env['action_controller.instance']).to be_a(Devise::FailureApp)
    end

    it "is successful" do
      sign_in(owner)
      get :edit, id: account.slug
      expect(response).to be_successful
    end
  end

  describe "PATCH #update" do
    it "requires authentication" do
      patch :update, id: account.slug
      expect(request.env['action_controller.instance']).to be_a(Devise::FailureApp)
    end

    it "redirects" do
      sign_in(owner)
      patch :update, id: account.slug, account: {name: 'Foo'}
      expect(response).to be_redirect
    end

    it "updates account" do
      sign_in(owner)
      expect {
        patch :update, id: account.slug, account: {
          name: 'foo',
          website_url: 'https://foo.com',
          webhook_url: 'https://foo.com/webhook'
        }
        account.reload
      }.to change { account.attributes }
    end
  end

end
