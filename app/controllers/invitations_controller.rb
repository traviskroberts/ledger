class InvitationsController < ApplicationController
  before_filter :require_user

  def show
    invitation = Invitation.find_by_token(params[:token])

    if invitation.present?
      invitation.account.add_user(current_user)
      invitation.destroy
      flash[:success] = "Invitation accepted!"
    else
      flash[:error] = 'The invitation was not found. It might not be valid anymore.'
    end

    redirect_to accounts_url
  end
end
