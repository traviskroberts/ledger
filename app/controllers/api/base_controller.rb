class Api::BaseController < ApplicationController
  before_filter :require_user

  def require_user
    unless current_user
      render json: {}, status: 401
    end
  end
end
