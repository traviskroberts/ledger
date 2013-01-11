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
  match 'accounts'                                => 'site#backbone'
  match 'accounts/new'                            => 'site#backbone'
  match 'accounts/:id'                            => 'site#backbone'
  match 'accounts/:id/edit'                       => 'site#backbone'
  match 'accounts/:id/sharing'                    => 'site#backbone'
  match 'accounts/:id/recurring'                  => 'site#backbone'
  match 'accounts/:id/recurring/new'              => 'site#backbone'
  match 'accounts/:account_id/recurring/:id/edit' => 'site#backbone'
  match 'users'                                   => 'site#backbone', :via => :get

  namespace :api do
    resources :accounts do
      resources :entries, :only => [:index, :create, :destroy]
      resources :invitations, :only => [:index, :create, :destroy]
      resources :recurring_transactions, :only => [:index, :create, :update, :destroy]
    end
    resources :users, :only => [:index]
  end

  resources :users, :except => [:edit]
end
