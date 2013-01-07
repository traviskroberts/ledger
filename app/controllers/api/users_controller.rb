class Api::UsersController < ApplicationController
  before_filter :require_admin

  respond_to :json

  def index
    @users = User.all
    respond_with(@users)
  end
end
