require 'spec_helper'

describe Api::AccountsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_parameters) { FactoryGirl.attributes_for(:account) }
  let(:updated_parameters) { {:name => 'Changed Account Name'} }

  before :each do
    activate_authlogic
    UserSession.create(user)
  end

  describe 'GET #index' do
    it 'should retrieve the accounts for the current user' do
      accounts = []
      2.times { accounts << FactoryGirl.create(:account, :users => [user]) }
      FactoryGirl.create(:account)

      get :index
      expect(assigns(:accounts)).to eq(accounts)
    end
  end

  describe 'GET #show' do
    it 'should retrieve the specified account' do
      account = FactoryGirl.create(:account, :users => [user])

      get :show, :id => account
      expect(assigns(:account)).to eq(account)
    end

    it 'should render a json representation of the account' do
      post :create, :account => valid_parameters, :format => 'json'
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end
  end

  describe 'POST #create' do
    it 'should create a new account' do
      post :create, :account => valid_parameters
      expect(Account.count).to eq(1)
    end

    it 'should assign the new account to the current user' do
      post :create, :account => valid_parameters
      expect(Account.first.users).to match_array([user])
    end

    it 'should render a json representation of the account' do
      post :create, :account => valid_parameters, :format => 'json'
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end

    it 'should render a 400 error on failure' do
      post :create, :account => {}
      expect(response.status).to eq(400)
    end
  end

  describe 'PUT #update' do
    it 'should update the attributes' do
      account = FactoryGirl.create(:account, :users => [user])

      put :update, :id => account, :account => updated_parameters
      updated_parameters.each do |field, value|
        expect(assigns(:account).send(field)).to eq(value)
      end
    end

    it 'should render a 400 error on failure' do
      account = FactoryGirl.create(:account, :users => [user])

      put :update, :id => account, :account => {:name => ''}
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy the specified account' do
      account = FactoryGirl.create(:account, :users => [user])

      delete :destroy, :id => account
      expect(user.reload.accounts).to be_blank
    end

    it 'should render a json representation of the account' do
      post :create, :account => valid_parameters, :format => 'json'
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end

    it 'should render a 400 error on failure' do
      account = FactoryGirl.create(:account, :users => [user])
      Account.any_instance.stub(:destroy).and_return(false)

      delete :destroy, :id => account
      expect(response.status).to eq(400)
    end
  end
end
