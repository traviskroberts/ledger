class Api::UsersController < ApplicationController
  before_filter :require_admin

  respond_to :json

  def index
    @users = User.all
    render :json => @users
  end
end
