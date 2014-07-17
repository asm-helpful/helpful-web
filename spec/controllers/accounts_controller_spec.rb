require "spec_helper"

describe AccountsController do

  let(:owner) { create(:user) }
  let(:account) { create(:account) }

  before do
    create(:membership, account: account, user: owner, role: 'owner')
  end


  describe 'visiting the new account page' do
    it 'is successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'creating an account' do
    it 'creates an account with the name and email specified' do
      post :create, {
        account: {
          name: 'Assembly',
          email: 'asm@helpful.io',
          billing_plan_slug: 'starter-kit'
        },
        person: {
          name: 'Patrick Van Stee'
        },
        user: {
          email: 'patrick@assebly.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      account = assigns(:account)
      person = assigns(:person)

      expect(response).to redirect_to(account_invitations_path(account))
      expect(account.name).to eq('Assembly')
      expect(account.slug).to eq('asm')
      expect(person.name).to eq('Patrick Van Stee')
    end
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
