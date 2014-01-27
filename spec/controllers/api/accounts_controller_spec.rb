require 'spec_helper'

describe Api::AccountsController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:account) { FactoryGirl.build_stubbed(:account, :url => 'test-account', :users => [user]) }
  let(:valid_parameters) { FactoryGirl.attributes_for(:account) }
  let(:updated_parameters) { {:name => 'Changed Account Name'} }

  before :each do
    controller.stub(:current_user => user)
  end

  describe 'GET #index' do
    it 'should retrieve the accounts for the current user' do
      user.should_receive(:accounts).and_return(account)
      account.should_receive(:order).with(:id)

      get :index
    end

    it 'should return a 401 error if the user is not authenticated' do
      controller.stub(:current_user => false)

      get :index
      expect(response.status).to eq(401)
    end
  end

  describe 'GET #show' do
    before :each do
      user.stub(:accounts => account)
      account.stub(:find_by_url => account)
    end

    it 'should retrieve the specified account' do
      account.should_receive(:find_by_url).and_return(account)

      get :show, :id => account, :format => 'json'
    end

    it 'should render a json representation of the account' do
      get :show, :id => account, :format => 'json'
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end
  end

  describe 'POST #create' do
    before :each do
      Account.stub(:new => account)
      account.stub(:save => true)
      controller.stub(:current_user => user)
      user.stub(:accounts => account)
      account.stub(:<<)
      account.stub(:reload => account)
    end

    it 'should create a new account' do
      Account.should_receive(:new).with(valid_parameters.stringify_keys).and_return(account)

      post :create, :account => valid_parameters
    end

    it 'should assign the new account to the current user' do
      account.should_receive(:<<).with(account)

      post :create, :account => valid_parameters
    end

    it 'should render a json representation of the account' do
      post :create, :account => valid_parameters, :format => 'json'
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end

    it 'should render a 400 error on failure' do
      account.stub(:save => false)

      post :create, :account => {}
      expect(response.status).to eq(400)
    end
  end

  describe 'PUT #update' do
    before :each do
      controller.stub(:current_user => user)
      user.stub_chain(:accounts, :find_by_url).and_return(account)
      account.stub(:reload => account)
    end

    it 'should update the attributes' do
      account.should_receive(:update_attributes).with(updated_parameters.stringify_keys).and_return(true)

      put :update, :id => account, :account => updated_parameters
    end

    it 'should render a json representation of the account' do
      account.stub(:update_attributes => true)

      put :update, :id => account, :account => updated_parameters, :format => 'json'
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end

    it 'should render a 400 error on failure' do
      account.stub(:update_attributes => false)

      put :update, :id => account, :account => {:name => ''}
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      controller.stub(:current_user => user)
      user.stub_chain(:accounts, :find_by_url).and_return(account)
    end

    it 'should destroy the specified account' do
      account.should_receive(:destroy).and_return(true)

      delete :destroy, :id => account
    end

    it 'should render a json representation of the account' do
      account.stub(:destroy => true)

      delete :destroy, :id => account, :format => 'json'
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:id, :name, :url, :dollar_balance])
    end

    it 'should render a 400 error on failure' do
      account.stub(:destroy => false)

      delete :destroy, :id => account
      expect(response.status).to eq(400)
    end
  end
end
