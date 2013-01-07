class Api::InvitationsController < ApplicationController
  before_filter :require_user, :load_account

  respond_to :json

  def index
    @invitations = @account.invitations
    respond_with(@invitations)
  end

  def create
    @invite = @account.invitations.new(params[:invitation])
    @invite.user = current_user
    @invite.token = SecureRandom.urlsafe_base64

    if @invite.save
      SiteMailer.delay.invitation(@invite)
      render :json => @invite
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end

  def destroy
    @invitation = @account.invitations.find(params[:id])

    if @invitation.destroy
      respond_with(@invitation)
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end

  private
    def load_account
      @account = current_user.accounts.find_by_url(params[:account_id])
    end
end
