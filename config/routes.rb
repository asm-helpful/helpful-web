Supportly::Application.routes.draw do
  
  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web, at: "/sidekiq"
  end
  
  get "conversations/index"
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
  resource :account, only: [:new, :create]
  resources :messages

  root to: 'pages#home'
  
  get '/widget' => 'pages#widget'

  scope ':account' do
    #resources :"", controller: 'conversations', as: 'conversations'
    resources :conversations
    get '/', to:'conversations#index'
  end
end
