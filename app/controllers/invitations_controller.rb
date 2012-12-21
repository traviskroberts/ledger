class InvitationsController < ApplicationController
  before_filter :require_user

  def show
    invitation = Invitation.find_by_token(params[:token])

    if invitation.present?
      invitation.account.users << current_user unless invitation.account.users.include?(current_user)
      invitation.destroy
      flash[:success] = "Invitation accepted!"
    else
      flash[:error] = 'The invitation was not found. It might not be valid anymore.'
    end

    redirect_to accounts_url
  end

  def create
    @account = current_user.accounts.find_by_url(params[:account_id])
    @invite = @account.invitations.new({
      :user => current_user,
      :email => params[:email],
      :token => SecureRandom.urlsafe_base64
    })

    if @invite.save
      SiteMailer.invitation(@invite).deliver
      flash[:success] = 'Invitation sent.'
    else
      flash[:error] = 'There was an error sending the invitation.'
    end

    redirect_to sharing_account_url(@account)
  end

  def destroy
    @account = current_user.accounts.find_by_url(params[:account_id])
    @invitation = @account.invitations.find(params[:id])

    if @invitation.destroy
      flash[:notice] = "Invitation removed."
    else
      flash[:error] = "There was an error removing the invitation."
    end

    redirect_to sharing_account_url(@account)
  end
end
