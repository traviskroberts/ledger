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
end
