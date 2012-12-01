class ApplicationController < ActionController::Base
  protect_from_forgery

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    helper_method :current_user

    def store_location
      session[:return_to] = request.fullpath
    end

    def redirect_back_or_home
      return_path = session[:return_to]
      session[:return_to] = nil
      redirect_to(return_path || root_url)
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = 'You must be logged in.'
        redirect_to login_url and return false
      end
    end

    def require_admin
      unless current_user && current_user.super_admin?
        store_location
        flash[:notice] = "You don't have permission to access that page."
        redirect_to root_url and return false
      end
    end

    def require_no_user
      if current_user
        flash[:notice] = 'You must be logged out to access that page.'
        redirect_to root_url and return false
      end
    end
end
