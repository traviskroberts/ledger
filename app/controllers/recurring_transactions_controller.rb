class RecurringTransactionsController < ApplicationController
  before_filter :require_user, :load_account

  def index
    @recurring_transactions = @account.recurring_transactions
  end

  def new
    @recurring_transaction = @account.recurring_transactions.new
  end

  def create
    @recurring_transaction = @account.recurring_transactions.new(params[:recurring_transaction])

    if @recurring_transaction.save
      flash[:success] = 'Recurring transaction scheduled.'
      redirect_to account_recurring_transactions_url(@account)
    else
      flash.now[:error] = 'There was a problem scheduling the recurring transaction.'
      render :new
    end
  end

  def edit
    @recurring_transaction = @account.recurring_transactions.find(params[:id])
    @recurring_transaction.float_amount = @recurring_transaction.dollar_amount
  end

  def update
    @recurring_transaction = @account.recurring_transactions.find(params[:id])

    if @recurring_transaction.update_attributes(params[:recurring_transaction])
      flash[:success] = 'The recurring transaction was updated.'
      redirect_to account_recurring_transactions_url(@account)
    else
      flash.now[:error] = 'There was a problem updating the recurring transaction.'
      render :edit
    end
  end

  def destroy
    @recurring_transaction = @account.recurring_transactions.find(params[:id])

    if @recurring_transaction.destroy
      flash[:notice] = 'The recurring transaction was deleted.'
    else
      flash[:error] = 'There was a problem deleting the recurring transaction.'
    end

    redirect_to account_recurring_transactions_url(@account)
  end

  private
    def load_account
      @account = current_user.accounts.find_by_url(params[:account_id])
    end
end
