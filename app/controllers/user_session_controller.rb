class UserSessionController < ApplicationController
  before_filter :require_user, :only => [:destroy]
  before_filter :require_no_user, :except => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      redirect_to root_url
    else
      flash.now[:error] = 'Username or password are incorrect.'
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "You've been logged out."
    redirect_to login_url
  end
end
