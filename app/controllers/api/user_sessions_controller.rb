class Api::UserSessionsController < Api::BaseController
  skip_before_filter :require_user, :only => [:create]

  def create
    user_session = UserSession.new(params[:user_session])

    if user_session.save
      render :json => current_user
    else
      render :json => {:errors => user_session.errors.full_messages}, :status => 401
    end
  end

  def destroy
    current_user_session.destroy
    render :json => {}, :status => 200
  end
end
