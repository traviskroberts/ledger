class Api::UsersController < Api::BaseController
  before_filter :require_admin, :only => [:index]
  skip_before_filter :require_user, :only => [:create]

  def index
    render :json => User.all
  end

  def create
    user = User.new(params[:user])

    if user.save
      UserSession.create(user)
      render :json => user
    else
      render :json => {:errors => user.errors.full_messages}, :status => 400
    end
  end

  def update
    user = current_user
    if user.update_attributes(params[:user])
      UserSession.create(user) # authlogic logs the user out when they change their password?
      render :json => user.reload
    else
      render :json => {:errors => user.errors.full_messages}, :status => 400
    end
  end
end
