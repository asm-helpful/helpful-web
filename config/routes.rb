Helpful::Application.routes.draw do

  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web, at: "/sidekiq"
    mount MessageMailerPreview, at: '/mail_view'
  end

  get '/embed.js' => 'pages#embed', :as => :embed
  get '/styleguide' => 'pages#styleguide', :as => :styleguide
  get '/docs' => 'pages#docs', :as => :docs

  devise_for :users, skip: :registrations, :controllers => { :invitations => 'users/invitations' }

  # This is the normal user registrations but NO new/create - That is handled by either:
  # * Account#new (for a new account and the first user)
  devise_scope :user do
    resource :registration,
             only: [:edit, :update, :destroy],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'devise/registrations',
             as: :user_registration do
      get :cancel
    end
  end

  resource :beta_invites, only: [:create]
  resource :account, only: [:new, :create, :edit, :update]
  resource :billing, only: [:show] do
    get :return
  end

  resources :messages

  namespace :webhooks do
    resources :mailgun, only: :create
  end

  post 'webhooks/chargify' => 'billings#webhook', :as => :webhook_billing

  namespace :api do
    match 'messages/create' => 'messages#create',
          :via => ["get", "post"],
          :defaults => { :format => 'json' }

    resources :messages, :defaults => { :format => 'json' } do
      resources :attachments, default: {format: 'json'}
    end
  end

  authenticated :user do
    root :to => 'conversations#index', :as => 'authenticated_root'
  end

  root to: 'pages#home'

  scope ':account' do
    resources :conversations
    resources :archive,
              only: [:index, :show, :update],
              controller: 'conversations/archived',
              as: 'archived_conversations'
  end
end
