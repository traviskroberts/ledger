require 'spec_helper'

describe Api::RecurringTransactionsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:account) { FactoryGirl.create(:account, :users => [user]) }
  let(:recurring_transaction) { FactoryGirl.create(:recurring_transaction, :account => account) }

  before :each do
    activate_authlogic
    UserSession.create(user)
  end

  describe 'GET #index' do
    before :each do
      @transactions = []
      3.times { @transactions << FactoryGirl.create(:recurring_transaction, :account => account) }
      2.times { FactoryGirl.create(:recurring_transaction) }
    end

    it 'should get a list of current recurring transactions' do
      get :index, :account_id => account
      expect(assigns(:recurring_transactions)).to match_array(@transactions)
    end

    it 'should render a json representation of the recurring transactions' do
      get :index, :account_id => account
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.first.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end
  end

  describe 'POST #create' do
    it 'should create a new recurring transaction' do
      post :create, :account_id => account, :recurring_transaction => {:day => 1, :float_amount => 14.52}
      expect(RecurringTransaction.count).to eq(1)
    end

    it 'should render a json representation of the created recurring transaction' do
      post :create, :account_id => account, :recurring_transaction => {:day => 1, :float_amount => 14.52}
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it 'should render a 400 status on error' do
      post :create, :account_id => account, :recurring_transaction => {}
      expect(response.status).to eq(400)
    end
  end

  describe 'PUT #update' do
    it 'should update the recurring transaction attributes' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {:day => 15, :float_amount => 45.41}
      expect(assigns(:recurring_transaction).day).to eq(15)
      expect(assigns(:recurring_transaction).amount).to eq(4541)
    end

    it 'render a json representation of the update recurring transaction' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {:day => 15, :float_amount => 45.41}
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it 'should return a 400 status on failure' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {}
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy the recurring transaction' do
      delete :destroy, :account_id => account, :id => recurring_transaction
      expect(RecurringTransaction.count).to eq(0)
    end

    it 'render a json representation of the deleted recurring transaction' do
      delete :destroy, :account_id => account, :id => recurring_transaction
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it 'should return a 400 status on failure' do
      RecurringTransaction.any_instance.stub(:destroy).and_return(false)
      delete :destroy, :account_id => account, :id => recurring_transaction
      expect(response.status).to eq(400)
    end
  end
end
