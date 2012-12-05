class AccountsController < ApplicationController
  before_filter :require_user

  def index
    @accounts = current_user.accounts
  end

  def show
    @account = current_user.accounts.find_by_url(params[:id])
  end

  def new
    @account = current_user.accounts.new
  end

  def create
    @account = Account.new(params[:account])

    if @account.save
      current_user.accounts << @account
      flash[:notice] = 'Account added.'
      redirect_to accounts_url
    else
      flash.now[:error] = 'There was a problem adding the account.'
      render :new
    end
  end

  def edit
    @account = current_user.accounts.find_by_url(params[:id])
  end

  def update
    @account = current_user.accounts.find_by_url(params[:id])

    if @account.update_attributes(params[:account])
      flash[:notice] = 'The account was updated.'
      redirect_to accounts_url
    else
      flash.now[:error] = 'There was a problem updating the account.'
      render :edit
    end
  end

  def destroy
    @account = current_user.accounts.find_by_url(params[:id])

    if @account.destroy
      flash[:notice] = 'The account was deleted.'
    else
      flash[:error] = 'There was a problem deleting the account.'
    end

    redirect_to accounts_url
  end

  def sharing
    @account = current_user.accounts.find_by_url(params[:id])
    @users = @account.users.reject { |user| user == current_user }
  end

  def invite
    @account = current_user.accounts.find_by_url(params[:id])
    @invite = Invitation.new({
      :account => @account,
      :user => current_user,
      :email => params[:email],
      :token => SecureRandom.urlsafe_base64
    })

    if @invite.save
      SiteMailer.delay.invitation(@invite)
      flash[:success] = 'Invitation sent.'
      redirect_to sharing_account_path(@account)
    else
      flash.now[:error] = 'There was an error sending the invitation.'
      render :sharing
    end

  end
end
