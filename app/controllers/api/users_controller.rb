class Api::UsersController < Api::BaseController
  before_filter :require_user
  before_filter :require_admin, :only => [:index]

  respond_to :json

  def index
    @users = User.all
    render :json => @users
  end

  def show
    render :json => current_user
  end
end
