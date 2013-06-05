class Api::EntriesController < Api::BaseController
  before_filter :load_account

  respond_to :json

  def index
    @entries = @account.entries.paginate(:page => params[:page], :per_page => 25)

    render :json => {
      :page => @entries.current_page,
      :total_pages => @entries.total_pages,
      :total_number => @entries.count,
      :entries => @entries
    }
  end

  def create
    @entry = @account.entries.new(params[:entry])
    @entry.date = Date.today

    if @entry.save
      render :json => {:entry => @entry, :account_balance => @entry.account.dollar_balance}
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end

  def update
    @entry = @account.entries.find(params[:id])

    if @entry.update_attributes(:description => params[:description], :float_amount => params[:float_amount], :date => params[:date])
      render :json => {:entry => @entry, :account_balance => @account.reload.dollar_balance}
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end

  def destroy
    @entry = @account.entries.find(params[:id])

    if @entry.destroy
      render :json => {:balance => @account.reload.dollar_balance}
    else
      render :json => {:message => 'Error'}, :status => 400
    end
  end

  def values
    entries = @account.entries.where('description LIKE ?', "#{params[:term]}%").pluck(:description).uniq
    render :json => {:values => entries}
  end

  private
    def load_account
      @account = current_user.accounts.find_by_url(params[:account_id])
    end
end
