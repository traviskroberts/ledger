class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]
  before_filter :require_admin, :only => [:index]

  def index
    @users = User.paginate(:page => params[:page], :per_page => 25)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = "Your account has been created."
      redirect_to login_url
    else
      flash.now[:error] = 'There was an error creting your account.'
      render :new
    end
  end

  def update
    if current_user.update_attributes(params[:user])
      flash[:success] = "Account updated."
      redirect_to my_account_url
    else
      flash.now[:error] = 'There was an error updating your account.'
      render :edit
    end
  end
end
