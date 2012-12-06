Ledger::Application.routes.draw do
  root :to => 'site#index'

  match '/login',     :to => 'user_session#new',      :as => :login,          :via => :get
  match '/login',     :to => 'user_session#create',   :as => :login,          :via => :post
  match '/logout',    :to => 'user_session#destroy',  :as => :logout,         :via => :delete
  match '/register',  :to => 'users#new',             :as => :register,       :via => :get
  match '/register',  :to => 'users#create',          :as => :register,       :via => :post

  match 'my-account', :to => 'users#edit',            :as => :my_account,     :via => :get
  match 'my-account', :to => 'users#update',          :as => :update_account, :via => :put

  match 'accept-invite/:token', :to => 'invitations#show', :as => :accept_invite

  resources :accounts do
    get :sharing, :on => :member
    resources :entries, :only => [:index, :create, :destroy]
    resources :invitations, :only => [:create, :destroy]
  end
  resources :users, :except => [:edit]

  # sidekiq webmin
  require 'sidekiq/web'
  require "admin_constraint"
  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new
end
