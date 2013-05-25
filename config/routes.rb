Ledger::Application.routes.draw do
  root :to => 'site#backbone'

  # Users
  # match 'register',  :to => 'users#new',     :as => :register,       :via => :get
  # match 'register',  :to => 'users#create',  :as => :register,       :via => :post
  # match 'my-account', :to => 'users#edit',    :as => :my_account,     :via => :get
  # match 'my-account', :to => 'users#update',  :as => :update_account, :via => :put

  # Invitations
  match 'accept-invite/:token', :to => 'invitations#show', :as => :accept_invite

  namespace :api do
    resources :accounts do
      resources :entries, :only => [:index, :create, :update, :destroy]
      resources :invitations, :only => [:index, :create, :destroy]
      resources :recurring_transactions, :only => [:index, :create, :update, :destroy]
    end
    resource :user_session, :only => [:create, :destroy]
    resources :users, :only => [:index]
  end

  resources :users, :except => [:edit]

  match '*backbone' => 'site#backbone'
end
