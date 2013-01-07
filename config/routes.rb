Ledger::Application.routes.draw do
  root :to => 'site#index'

  # UserSessions
  match '/login',     :to => 'user_session#new',      :as => :login,          :via => :get
  match '/login',     :to => 'user_session#create',   :as => :login,          :via => :post
  match '/logout',    :to => 'user_session#destroy',  :as => :logout,         :via => :delete

  # Users
  match '/register',  :to => 'users#new',     :as => :register,       :via => :get
  match '/register',  :to => 'users#create',  :as => :register,       :via => :post
  match 'my-account', :to => 'users#edit',    :as => :my_account,     :via => :get
  match 'my-account', :to => 'users#update',  :as => :update_account, :via => :put

  # Invitations
  match 'accept-invite/:token', :to => 'invitations#show', :as => :accept_invite

  # bogus routes to make sure the app is bootstrapped correctly
  match 'accounts'              => 'accounts#backbone'
  match 'accounts/new'          => 'accounts#backbone'
  match 'accounts/:id'          => 'accounts#backbone'
  match 'accounts/:id/edit'     => 'accounts#backbone'
  match 'accounts/:id/sharing'  => 'accounts#backbone'
  match 'users'                 => 'accounts#backbone', :via => :get

  namespace :api do
    resources :accounts do
      resources :entries, :only => [:index, :create, :destroy]
      resources :invitations, :only => [:index, :create, :destroy]
    end
    resources :users, :only => [:index]
  end

  resources :accounts do
    get :sharing, :on => :member
    resources :entries, :only => [:index, :create, :destroy]
    resources :invitations, :only => [:create, :destroy]
    resources :recurring_transactions, :except => [:show]
  end

  resources :users, :except => [:edit]
end
