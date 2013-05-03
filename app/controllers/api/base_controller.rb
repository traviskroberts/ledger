class Api::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token

  private
    def require_user
      unless current_user
        render(:json => {:message => 'Authentication required.'}, :status => 401) and return false
      end
    end

end
