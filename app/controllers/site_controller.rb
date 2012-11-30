class SiteController < ApplicationController
  before_filter :redirect_users

  private
    def redirect_users
      if current_user
        redirect_to accounts_url
      end
    end
end
