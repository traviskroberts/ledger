require 'spec_helper'

describe Api::EntriesController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:account) { FactoryGirl.build_stubbed(:account, :url => 'test-account', :users => [user]) }
  let(:entry) { FactoryGirl.build_stubbed(:entry, :account => account) }
  let(:entries) { FactoryGirl.build_list(:entry, 2, :account => account) }

  before :each do
    controller.stub(:current_user => user)
    user.stub_chain(:accounts, :find_by_url).and_return(account)
    account.stub(:entries => entries)
    entries.stub(:paginate => entries)
    entries.stub(:current_page => 1)
    entries.stub(:total_pages => 3)
  end

  describe 'GET #index' do
    it 'should get the entries for the specified account' do
      account.should_receive(:entries).and_return(entries)

      get :index, :account_id => account
    end

    it 'should paginate the entries' do
      entries.should_receive(:paginate).with(:page => nil, :per_page => 25)

      get :index, :account_id => account
    end

    it 'should return a json representation of the entries' do
      get :index, :account_id => account, :format => 'json'
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:page, :total_pages, :total_number, :entries])
    end
  end

  describe 'POST #create' do
    let(:new_params) { {:float_amount => '1.23', :description => 'lunch', :date => Date.today.strftime("%Y-%m-%d")} }

    before :each do
      entries.stub(:new => entry)
      entry.stub(:save => true)
    end

    it 'should create the entry object' do
      entries.should_receive(:new).with(new_params.stringify_keys).and_return(entry)

      post :create, :account_id => account, :entry => new_params
    end

    it 'should persist the entry' do
      entry.should_receive(:save).and_return(true)

      post :create, :account_id => account, :entry => new_params
    end

    it 'should render a json representation of the entry' do
      post :create, :account_id => account, :entry => new_params
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr[:entry].keys).to match_array([:classification, :description, :id, :formatted_amount, :formatted_date, :timestamp, :form_amount_value])
    end

    it 'should render a json representation of the updated account balance' do
      post :create, :account_id => account, :entry => new_params
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to include(:account_balance)
    end

    it 'should render a 400 error on failure' do
      entry.stub(:save => false)

      post :create, :account_id => account, :entry => {}
      expect(response.status).to eq(400)
    end
  end

  describe 'PUT #update' do
    let(:update_params) { {:float_amount => '-9.17', :description => 'lunch', :date => Date.today.strftime("%Y-%m-%d")} }

    before :each do
      account.stub_chain(:entries, :find).and_return(entry)
      account.stub(:reload => account)
    end

    it 'should update the entry attributes' do
      entry.should_receive(:update_attributes).with(update_params).and_return(true)

      put :update, {:account_id => account, :id => entry}.merge(update_params)
    end

    it 'should return a json representation of the entry' do
      entry.stub(:update_attributes => true)

      put :update, {:account_id => account, :id => entry}.merge(update_params)
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:account_balance, :entry])
    end

    it 'should return a 400 status on failure' do
      entry.stub(:update_attributes => false)

      put :update, {:account_id => account, :id => entry}.merge(update_params)
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      account.stub_chain(:entries, :find).and_return(entry)
      account.stub(:reload => account)
    end

    it 'should destroy the specified entry' do
      entry.should_receive(:destroy).and_return(true)

      delete :destroy, :account_id => account, :id => entry
    end

    it 'should return a json representation of the updated account balance' do
      entry.stub(:destroy => true)

      delete :destroy, :account_id => account, :id => entry
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr[:balance]).not_to be_blank
    end

    it 'should return a 400 status on failure' do
      entry.stub(:destroy => false)

      delete :destroy, :account_id => account, :id => entry
      expect(response.status).to eq(400)
    end
  end
end
