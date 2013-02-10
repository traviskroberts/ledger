require 'spec_helper'

describe Api::RecurringTransactionsController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:account) { FactoryGirl.build_stubbed(:account, :url => 'test-account', :users => [user]) }
  let(:recurring_transaction) { FactoryGirl.build_stubbed(:recurring_transaction, :account => account) }

  before :each do
    controller.stub(:current_user => user)
    user.stub_chain(:accounts, :find_by_url).and_return(account)
  end

  describe 'GET #index' do
    it 'should get a list of current recurring transactions' do
      account.should_receive(:recurring_transactions).and_return(recurring_transaction)

      get :index, :account_id => account
    end

    it 'should render a json representation of the recurring transactions' do
      account.stub(:recurring_transactions => [recurring_transaction])

      get :index, :account_id => account
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.first.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end
  end

  describe 'POST #create' do
    before :each do
      account.stub_chain(:recurring_transactions, :new).and_return(recurring_transaction)
      recurring_transaction.stub(:save => true)
    end

    it 'should create a new recurring transaction' do
      account.stub(:recurring_transactions => recurring_transaction)
      recurring_transaction.should_receive(:new).with('day' => '1', 'float_amount' => '14.52').and_return(recurring_transaction)

      post :create, :account_id => account, :recurring_transaction => {:day => 1, :float_amount => 14.52}
    end

    it 'should persiste the recurring transaction' do
      recurring_transaction.should_receive(:save).and_return(true)

      post :create, :account_id => account, :recurring_transaction => {:day => 1, :float_amount => 14.52}
    end

    it 'should render a json representation of the created recurring transaction' do
      post :create, :account_id => account, :recurring_transaction => {:day => 1, :float_amount => 14.52}
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it 'should render a 400 status on error' do
      recurring_transaction.stub(:save => false)

      post :create, :account_id => account, :recurring_transaction => {}
      expect(response.status).to eq(400)
    end
  end

  describe 'PUT #update' do
    let(:update_params) { {'day' => '15', 'float_amount' => '45.41'} }

    before :each do
      account.stub_chain(:recurring_transactions, :find).and_return(recurring_transaction)
      recurring_transaction.stub(:update_attributes => true)
    end

    it 'should update the recurring transaction attributes' do
      recurring_transaction.should_receive(:update_attributes).with(update_params).and_return(true)

      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => update_params
    end

    it 'render a json representation of the updated recurring transaction' do
      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => update_params
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it 'should return a 400 status on failure' do
      recurring_transaction.stub(:update_attributes => false)

      put :update, :account_id => account, :id => recurring_transaction, :recurring_transaction => {}
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      account.stub_chain(:recurring_transactions, :find).and_return(recurring_transaction)
      recurring_transaction.stub(:destroy => true)
    end

    it 'should destroy the recurring transaction' do
      recurring_transaction.should_receive(:destroy).and_return(true)

      delete :destroy, :account_id => account, :id => recurring_transaction
    end

    it 'render a json representation of the deleted recurring transaction' do
      delete :destroy, :account_id => account, :id => recurring_transaction
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:classification, :day, :description, :id, :formatted_amount, :form_amount_value])
    end

    it 'should return a 400 status on failure' do
      recurring_transaction.stub(:destroy => false)

      delete :destroy, :account_id => account, :id => recurring_transaction
      expect(response.status).to eq(400)
    end
  end
end
