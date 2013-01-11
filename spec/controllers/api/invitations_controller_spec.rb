require 'spec_helper'

describe Api::InvitationsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:account) { FactoryGirl.create(:account, :users => [user]) }
  let(:invite) { FactoryGirl.create(:invitation, :account => account, :user => user) }

  before :each do
    activate_authlogic
    UserSession.create(user)
  end

  describe 'POST #create' do
    it 'should load the account using the url slug' do
      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
      expect(assigns(:account)).to eq(account)
    end

    it 'should create an invite associated with the account' do
      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
      expect(Invitation.first.account).to eq(account)
    end

    it 'should create an invite associated with the current user' do
      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
      expect(Invitation.first.user).to eq(user)
    end

    it 'should render a json representation of the invite on success' do
      post :create, :account_id => account, :invitation => {:email => 'user@email.com'}
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to eq([:account_id, :email, :token, :user_id])
    end

    it 'should render a 400 error on failure' do
      post :create, :account_id => account
      expect(response.status).to eq(400)
    end
  end

  describe 'DELETE #destroy' do
    it 'should load the account using the url slug' do
      delete :destroy, :account_id => account, :id => invite
      expect(assigns(:account)).to eq(account)
    end

    it 'should load the specified invitation' do
      delete :destroy, :account_id => account, :id => invite
      expect(assigns(:invitation)).to eq(invite)
    end

    it 'should destroy the specified invitation' do
      delete :destroy, :account_id => account, :id => invite
      expect(Invitation.count).to eq(0)
    end

    it 'should render a json representation of the invite on success' do
      delete :destroy, :account_id => account, :id => invite
      jsr = JSON.parse(response.body, :symbolize_names => true)
      expect(jsr.keys).to eq([:account_id, :email, :token, :user_id])
    end

    it 'should render a 400 error on failure' do
      Invitation.any_instance.stub(:destroy).and_return(false)
      delete :destroy, :account_id => account, :id => invite
      expect(response.status).to eq(400)
    end
  end
end
