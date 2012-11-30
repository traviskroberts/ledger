class EntriesController < ApplicationController
  before_filter :require_user, :load_account

  layout false

  def index
    @entries = @account.entries.paginate(:page => params[:page], :per_page => 25)

    render :partial => 'list', :locals => {:entries => @entries}
  end

  def create
    entry = @account.entries.new(params[:entry])

    unless entry.save
      flash[:error] = "There was an error adding the entry."
    end

    redirect_to account_url(@account)
  end

  private
    def load_account
      @account = current_user.accounts.find_by_url(params[:account_id])
    end
end
