Supportly::Application.routes.draw do

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web, at: "/sidekiq"
  end

  get '/embed.js' => 'pages#embed', :as => :embed
  get '/styleguide' => 'pages#styleguide', :as => :styleguide

  devise_for :users, skip: :registrations

  # This is the normal user registrations but NO new/create - That is handled by either:
  # * Users#new (for new users to an existing acct) or
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
  resource :account, only: [:new, :create, :edit]

  resources :messages

  namespace :incoming_emails do
    resources :mailgun, only: :create
  end

  namespace :api do
   match 'messages/create' => 'messages#create', :via => ["get", "post"], :defaults => { :format => 'json' }
   resources :messages, :defaults => { :format => 'json' }
  end

  authenticated :user do
    root :to => 'conversations#index', :as => 'authenticated_root'
  end

  root to: 'pages#home'

  scope ':account' do
    resources :conversations
  end
end
