require 'spec_helper'

describe Api::InvitationsController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:account) { FactoryGirl.build_stubbed(:account, :url => 'test-account', :users => [user]) }
  let(:invite) { FactoryGirl.build_stubbed(:invitation, :account => account, :user => user) }

  before :each do
    controller.stub(:current_user => user)
    user.stub_chain(:accounts, :find_by_url).and_return(account)
  end

  describe 'GET #index' do
    it 'should get the invitations for the specified account' do
      account.should_receive(:invitations).and_return(invite)

      get :index, :account_id => account
    end
  end

  describe 'POST #create' do
    before :each do
      account.stub_chain(:invitations => invite)
      invite.stub(:new => invite)
      invite.stub(:save => true)
    end

    it 'should load the account using the url slug' do
      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
      expect(assigns(:account)).to eq(account)
    end

    it 'should create an invite associated with the account' do
      invite.should_receive(:new).with('email' => 'user@email.com')

      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
    end

    it 'should create an invite associated with the current user' do
      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
      expect(invite.user).to eq(user)
    end

    it 'should create a unique token for the invitation' do
      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
      expect(invite.token).to be_present
    end

    it 'should render a json representation of the invite on success' do
      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to eq([:account_id, :email, :token, :user_id])
    end

    it 'should render a 400 error on failure' do
      invite.stub(:save => false)

      post :create, :account_id => account
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      account.stub_chain(:invitations, :find).and_return(invite)
      invite.stub(:destroy => true)
    end

    it 'should load the account using the url slug' do
      delete :destroy, :account_id => account, :id => invite
      expect(assigns(:account)).to eq(account)
    end

    it 'should load the specified invitation' do
      delete :destroy, :account_id => account, :id => invite
      expect(assigns(:invitation)).to eq(invite)
    end

    it 'should destroy the specified invitation' do
      invite.should_receive(:destroy).and_return(true)

      delete :destroy, :account_id => account, :id => invite
    end

    it 'should render a json representation of the invite on success' do
      delete :destroy, :account_id => account, :id => invite
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to eq([:account_id, :email, :token, :user_id])
    end

    it 'should render a 400 error on failure' do
      invite.stub(:destroy => false)
      delete :destroy, :account_id => account, :id => invite
      expect(response.status).to eq(400)
    end
  end
end
