require 'spec_helper'

describe InvitationsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:account) { FactoryGirl.create(:account, :users => [user]) }
  let(:invite) { FactoryGirl.create(:invitation, :account => account, :user => user) }

  before :each do
    activate_authlogic
    UserSession.create(user)
  end

  describe 'GET #show' do
    it 'should retrieve the invitation by token' do
      Invitation.should_receive(:find_by_token).with(invite.token).and_return(invite)
      get :show, :token => invite.token
    end

    it 'should assign the new user to the account' do
      new_user = FactoryGirl.create(:user)
      UserSession.create(new_user)

      get :show, :token => invite.token
      expect(account.reload.users).to include(new_user)
    end

    it 'should not assign the user if they already have access to the account' do
      get :show, :token => invite.token
      expect(account.reload.users.length).to eq(1)
    end

    it 'should destroy the invitation' do
      get :show, :token => invite.token
      expect(Invitation.count).to eq(0)
    end

    it 'should set a flash message on success' do
      get :show, :token => invite.token
      expect(flash[:success]).to be_present
    end

    it 'should set a flash message on failure' do
      get :show, :token => 'bogustoken'
      expect(flash[:error]).to be_present
    end

    it 'should redirect the user to the accounts page' do
      get :show, :token => invite.token
      expect(response).to redirect_to(accounts_url)
    end
  end

  describe 'POST #create' do
    it 'should load the account using the url slug' do
      post :create, :account_id => account, :email => 'user@email.com'
      expect(assigns(:account)).to eq(account)
    end

    it 'should create an invite associated with the account' do
      post :create, :account_id => account, :email => 'user@email.com'
      expect(Invitation.first.account).to eq(account)
    end

    it 'should create an invite associated with the current user' do
      post :create, :account_id => account, :email => 'user@email.com'
      expect(Invitation.first.user).to eq(user)
    end

    it 'should set a flash message on success' do
      post :create, :account_id => account, :email => 'user@email.com'
      expect(flash[:success]).to be_present
    end

    it 'should set a flash message on failure' do
      post :create, :account_id => account
      expect(flash[:error]).to be_present
    end

    it 'should redirect to the sharing page' do
      post :create, :account_id => account, :email => 'user@email.com'
      expect(response).to redirect_to(sharing_account_url(account))
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

    it 'should set a flash message on success' do
      delete :destroy, :account_id => account, :id => invite
      expect(flash[:notice]).to be_present
    end

    it 'should set a flash message on failure' do
      Invitation.any_instance.stub(:destroy).and_return(false)
      delete :destroy, :account_id => account, :id => invite
      expect(flash[:error]).to be_present
    end

    it 'should redirect to the sharing page' do
      delete :destroy, :account_id => account, :id => invite
      expect(response).to redirect_to(sharing_account_url(account))
    end
  end

end
