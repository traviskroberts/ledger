class UsersController < ApplicationController
  before_filter :require_no_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = "Your account has been created."
      redirect_to login_url
    else
      flash.now[:error] = 'There was an error creting your account.'
      render :new
    end
  end
end
