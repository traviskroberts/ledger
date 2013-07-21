class Api::AccountsController < Api::BaseController
  respond_to :json

  def index
    @accounts = current_user.accounts.order(:id)
    respond_with(@accounts)
  end

  def show
    @account = current_user.accounts.find_by_url(params[:id])
    respond_with(@account)
  end

  def create
    @account = Account.new(params[:account])

    if @account.save
      current_user.accounts << @account
      render :json => @account.reload
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end

  def update
    @account = current_user.accounts.find_by_url(params[:id])

    if @account.update_attributes(params[:account])
      render :json => @account # respond_with is being a lil' bitch
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end

  def destroy
    @account = current_user.accounts.find_by_url(params[:id])

    if @account.destroy
      render :json => @account
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end
end
