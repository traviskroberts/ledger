Ledger::Application.routes.draw do
  root :to => 'site#index'

  # Invitations
  match 'accept-invite/:token', :to => 'invitations#show', :as => :accept_invite

  namespace :api do
    resources :accounts do
      resources :entries, :only => [:index, :create, :update, :destroy]
      resources :invitations, :only => [:index, :create, :destroy]
      resources :recurring_transactions, :only => [:index, :create, :update, :destroy]
    end
    resource  :user_session, :only => [:create, :destroy]
    resources :users, :only => [:index, :show, :update]
  end

  match '*page' => 'site#index'
end
