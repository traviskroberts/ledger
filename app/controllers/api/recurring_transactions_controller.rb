class Api::RecurringTransactionsController < Api::BaseController
  before_filter :require_user, :load_account

  respond_to :json

  def index
    @recurring_transactions = @account.recurring_transactions
    render :json => @recurring_transactions
  end

  def create
    @recurring_transaction = @account.recurring_transactions.new(params[:recurring_transaction])

    if @recurring_transaction.save
      render :json => @recurring_transaction
    else
      render :json => {:message => 'Error'}, :status => 422
    end
  end

  def update
    @recurring_transaction = @account.recurring_transactions.find(params[:id])

    if @recurring_transaction.update_attributes(params[:recurring_transaction])
      render :json => @recurring_transaction
    else
      render :json => {:message => 'Error'}, :status => 422
    end
  end

  def destroy
    @recurring_transaction = @account.recurring_transactions.find(params[:id])

    if @recurring_transaction.destroy
      render :json => @recurring_transaction
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end

  private
    def load_account
      @account = current_user.accounts.find_by_url(params[:account_id])
    end
end
