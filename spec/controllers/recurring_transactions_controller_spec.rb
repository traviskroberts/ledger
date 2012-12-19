require 'spec_helper'

describe RecurringTransactionsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:account) { FactoryGirl.create(:account, :users => [user]) }
  let(:recurring_transaction) { FactoryGirl.create(:recurring_transaction, :account => account) }

  before :each do
    activate_authlogic
    UserSession.create(user)
  end

  describe 'GET #index' do
    it 'should get a list of current recurring transactions' do
      transactions = []
      3.times { transactions << FactoryGirl.create(:recurring_transaction, :account => account) }
      2.times { FactoryGirl.create(:recurring_transaction) }

      get :index, :account_id => account
      expect(assigns(:recurring_transactions)).to match_array(transactions)
    end
  end

  describe 'GET #new' do
    it 'should create a new instance of a recurring transaction' do
      get :new, :account_id => account
      expect(assigns(:recurring_transaction).class).to eq(RecurringTransaction)
    end
  end

  describe 'POST #create' do
    it 'should create a new recurring transaction' do
      post :create, :account_id => account, :recurring_transaction => {:day => 1, :float_amount => 14.52}
      expect(RecurringTransaction.count).to eq(1)
    end

    it 'should set a flash message on success' do
      post :create, :account_id => account, :recurring_transaction => {:day => 1, :float_amount => 14.52}
      expect(flash[:success]).to be_present
    end

    it 'should redirect to #index on success' do
      post :create, :account_id => account, :recurring_transaction => {:day => 1, :float_amount => 14.52}
      expect(response).to redirect_to(account_recurring_transactions_url(account))
    end

    it 'should set a flash message on failure' do
      post :create, :account_id => account, :recurring_transaction => {}
      expect(flash[:error]).to be_present
    end

    it 'should render the new template on failure' do
      post :create, :account_id => account, :recurring_transaction => {}
      expect(response).to render_template('recurring_transactions/new')
    end
  end

  describe 'GET #edit' do
    it 'should retrieve the recurring transaction' do
      get :edit, :account_id => account, :id => recurring_transaction
      expect(assigns(:recurring_transaction)).to eq(recurring_transaction)
    end
  end

  describe 'PUT #update' do
    it 'should update the recurring transaction attributes' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {:day => 15, :float_amount => 45.41}
      expect(assigns(:recurring_transaction).day).to eq(15)
      expect(assigns(:recurring_transaction).amount).to eq(4541)
    end

    it 'should set a flash message on success' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {:day => 15, :float_amount => 45.41}
      expect(flash[:success]).to be_present
    end

    it 'should redirect to the #index on success' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {:day => 15, :float_amount => 45.41}
      expect(response).to redirect_to(account_recurring_transactions_url(account))
    end

    it 'should set a flash message on failure' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {}
      expect(flash[:error]).to be_present
    end

    it 'should render the edit template on failure' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {}
      expect(response).to render_template('recurring_transactions/edit')
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy the recurring transaction' do
      delete :destroy, :account_id => account, :id => recurring_transaction
      expect(RecurringTransaction.count).to eq(0)
    end

    it 'should set a flash message on success' do
      delete :destroy, :account_id => account, :id => recurring_transaction
      expect(flash[:notice]).to be_present
    end

    it 'should redirect to #index on success' do
      delete :destroy, :account_id => account, :id => recurring_transaction
      expect(response).to redirect_to(account_recurring_transactions_url(account))
    end

    it 'should set a flash message on failure' do
      RecurringTransaction.any_instance.stub(:destroy).and_return(false)
      delete :destroy, :account_id => account, :id => recurring_transaction
      expect(flash[:error]).to be_present
    end

    it 'should redirect to #index on failure' do
      RecurringTransaction.any_instance.stub(:destroy).and_return(false)
      delete :destroy, :account_id => account, :id => recurring_transaction
      expect(response).to redirect_to(account_recurring_transactions_url(account))
    end
  end
end
