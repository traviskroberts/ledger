class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:update]

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:success] = "Your account has been created."
      UserSession.create(@user, true)
      redirect_to accounts_url
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
