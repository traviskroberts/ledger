class Api::AccountsController < Api::BaseController
  before_filter :require_user

  respond_to :json

  def index
    @accounts = current_user.accounts.includes(:entries)
    respond_with(@accounts)
  end

  def show
    @account = current_user.accounts.find(params[:id])
    respond_with(@account)
  end

  def create
    account_params = params[:account].except(:url, :dollar_balance, :user_id)
    @account = Account.new(account_params)

    if @account.save
      current_user.accounts << @account
      render :json => @account.reload
    else
      render :json => {:message => 'Error'}, :status => 422
    end
  end

  def update
    @account = current_user.accounts.find(params[:id])

    account_params = {:name => params[:account][:name]}
    if @account.update_attributes(account_params)
      render :json => @account # respond_with is being a lil' bitch
    else
      render :json => {:message => 'Error'}, :status => 422
    end
  end

  def destroy
    @account = current_user.accounts.find(params[:id])

    if @account.destroy
      render :json => @account, status: 204
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end
end
