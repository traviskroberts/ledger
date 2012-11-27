Ledger::Application.routes.draw do
  root :to => 'site#index'

  match '/login',     :to => 'user_session#new',      :as => :login,    :via => :get
  match '/login',     :to => 'user_session#create',   :as => :login,    :via => :post
  match '/logout',    :to => 'user_session#destroy',  :as => :logout,   :via => :delete
  match '/register',  :to => 'users#new',             :as => :register, :via => :get
  match '/register',  :to => 'users#create',          :as => :register, :via => :post
end
