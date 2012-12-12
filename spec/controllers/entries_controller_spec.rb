require 'spec_helper'

describe EntriesController do

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

    it 'should render the list partial' do
      get :index, :account_id => account
      expect(response).to render_template('entries/_list')
    end
  end

  describe 'POST #create' do
    it 'assign the entry to the specified account' do
      post :create, :account_id => account, :entry => {:float_amount => '1.23', :description => 'lunch'}
      expect(account.entries.count).to eq(2)
    end

    it 'should redirect to the account show page' do
      post :create, :account_id => account, :entry => {:float_amount => '1.23', :description => 'lunch'}
      expect(response).to redirect_to(account_url(account))
    end

    it 'should set a flash message on failure' do
      post :create, :account_id => account, :entry => {}
      expect(flash[:error]).not_to be_blank
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

    it 'should return a 403 status on failure' do
      Entry.any_instance.stub(:destroy).and_return(false)
      entry = FactoryGirl.create(:entry, :account => account)

      delete :destroy, :account_id => account, :id => entry
      expect(response.status).to eq(403)
    end
  end
end
