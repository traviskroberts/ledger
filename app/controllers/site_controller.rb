class SiteController < ApplicationController
  # before_filter :redirect_users, :only => [:index]
  before_filter :require_user, :only => [:backbone]

  def backbone
    @accounts = current_user.accounts
  end

  private
    def redirect_users
      if current_user
        redirect_to accounts_url
      end
    end
end
