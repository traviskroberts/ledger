class SiteController < ApplicationController
  # before_filter :require_user
  # before_filter :redirect_users, :except => [:backbone]

  def backbone
    if current_user
      @accounts = current_user.accounts
    end
  end

  # private
  #   def redirect_users
  #     if current_user
  #       redirect_to accounts_url
  #     end
  #   end
end
