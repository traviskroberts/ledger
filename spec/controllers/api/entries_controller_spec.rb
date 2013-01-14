require 'spec_helper'

describe Api::EntriesController do
  let(:account) { FactoryGirl.create(:account) }

  before :each do
    activate_authlogic
    user = FactoryGirl.create(:user)
    user.accounts << account
    UserSession.create(user)
  end

  describe 'GET #index' do
    it 'should get the entries for the specified account' do
      entries = [account.entries.first]
      3.times { entries << FactoryGirl.create(:entry, :account => account) }

      get :index, :account_id => account
      expect(assigns(:entries)).to match_array(entries)
    end

    it 'should paginate the entries' do
      26.times { FactoryGirl.create(:entry, :account => account) }

      get :index, :account_id => account
      expect(assigns(:entries).length).to eq(25)
    end

    it 'should return a json representation of the entries' do
      5.times { FactoryGirl.create(:entry, :account => account) }

      get :index, :account_id => account
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to match_array([:page, :total_pages, :total_number, :entries])
    end
  end

  describe 'POST #create' do
    it 'assign the entry to the specified account' do
      post :create, :account_id => account, :entry => {:float_amount => '1.23', :description => 'lunch'}
      expect(account.entries.count).to eq(2)
    end

    it 'should render a json representation of the entry' do
      post :create, :account_id => account, :entry => {:float_amount => '1.23', :description => 'lunch'}
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr[:entry].keys).to match_array([:classification, :description, :id, :formatted_amount, :timestamp])
    end

    it 'should render a json representation of the updated account balance' do
      post :create, :account_id => account, :entry => {:float_amount => '1.23', :description => 'lunch'}
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to include(:account_balance)
    end

    it 'should render a 400 error on failure' do
      post :create, :account_id => account, :entry => {}
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy the specified entry' do
      entry = FactoryGirl.create(:entry, :account => account)

      delete :destroy, :account_id => account, :id => entry
      expect(account.entries.length).to eq(1)
    end

    it 'should return a json representation of the updated account balance' do
      entry = FactoryGirl.create(:entry, :account => account)

      delete :destroy, :account_id => account, :id => entry
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr[:balance]).not_to be_blank
    end

    it 'should return a 400 status on failure' do
      Entry.any_instance.stub(:destroy).and_return(false)
      entry = FactoryGirl.create(:entry, :account => account)

      delete :destroy, :account_id => account, :id => entry
      expect(response.status).to eq(400)
    end
  end
end
