Helpful::Application.routes.draw do

  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web, at: "/sidekiq"
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

  namespace :webhooks do
    resources :mailgun, only: :create
  end

  post 'webhooks/chargify' => 'billings#webhook', :as => :webhook_billing

  namespace :api, format: 'json' do
    resources :accounts, except: [:new, :edit, :destroy] do
      resources :conversations, shallow: true, except: [:new, :edit, :destroy] do
        resources :messages, shallow: true, except: [:new, :edit, :destroy] do
          resources :attachments, shallow: true, except: [:new, :edit, :destroy]
        end
      end

      resources :people, shallow: true, except: [:new, :edit, :destroy]
    end
  end

  resource :incoming_message, only: [:create]

  authenticated :user do
    root :to => 'dashboard#show', :as => 'authenticated_root'
    get '/settings' => 'users#edit', as: :edit_user
    resources :users, only: [:update]
  end

  resource :accounts, only: [:new, :create]

  scope '/:id' do
    resource :account, path: '/', only: [:show, :edit, :update] do
      resources :invitations

      get :configuration
      get :web_form
    end
  end

  scope '/:account_id', as: :account do
    resources :canned_responses

    resources :textcompletes, only: [:index]

    resources :conversations, path: '/', only: [:show, :update] do
      get :archived, on: :collection
      get :inbox, on: :collection
      get :search, on: :collection
      get :list, on: :collection

      resources :tags, only: [:create]
      resources :assignee, only: [:create]
    end

    resources :messages, only: [:create]
    resource :billing, only: [:show] do
      get :return
    end
  end

  unauthenticated :user do
    root to: 'pages#home'
  end
end
