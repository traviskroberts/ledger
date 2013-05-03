class Api::UserSessionsController < Api::BaseController
  before_filter :require_user, :only => [:destroy]

  def create
    if (params[:email].blank? || params[:password].blank?) && params[:remember_token].blank?
      render :json => {}, :status => 400 and return
    end

    if params[:remember_token].present?
      user = User.find_by_single_access_token(params[:remember_token])
      user_session = UserSession.create(user) unless user.blank?
    else
      user_session = UserSession.new(:email => params[:email], :password => params[:password])
    end

    if user_session && user_session.save
      current_user.reset_single_access_token! unless params[:remember_token].present?
      data = {
        :auth_token => current_user.single_access_token,
        :user_id => current_user.id
      }
      if params[:remember_me]
        data[:remember_token] = current_user.single_access_token
      end

      render :json => data, :status => 201
    else
      render :json => {}, :status => 401
    end
  end

  def destroy
    if current_user
      current_user.reset_single_access_token!
      render :json => {:user_id => current_user.id}, :status => 200
    else
      render :json => {}, :status => 400
    end
  end

end
