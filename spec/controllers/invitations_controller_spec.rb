require 'spec_helper'

describe InvitationsController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:account) { FactoryGirl.build_stubbed(:account, :users => [user]) }
  let(:invite) { FactoryGirl.build_stubbed(:invitation, :account => account, :user => user) }

  before :each do
    controller.stub(:current_user => user)
    Invitation.stub(:find_by_token => invite)
    invite.stub(:account => account)
    invite.stub(:destroy)
  end

  describe 'GET #show' do
    it 'should retrieve the invitation by token' do
      Invitation.should_receive(:find_by_token).with(invite.token).and_return(invite)

      get :show, :token => invite.token
    end

    it 'should assign the new user to the account' do
      new_user = FactoryGirl.build_stubbed(:user)
      controller.stub(:current_user => new_user)
      account.should_receive(:add_user).with(new_user)

      get :show, :token => invite.token
    end

    it 'should destroy the invitation' do
      invite.should_receive(:destroy)

      get :show, :token => invite.token
    end

    it 'should set a flash message on success' do
      get :show, :token => invite.token
      expect(flash[:success]).to be_present
    end

    it 'should set a flash message on failure' do
      invite.stub(:present? => false)

      get :show, :token => 'bogustoken'
      expect(flash[:error]).to be_present
    end

    it 'should redirect the user to the accounts page' do
      get :show, :token => invite.token
      expect(response).to redirect_to(root_url)
    end
  end
end
