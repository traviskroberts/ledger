require 'spec_helper'

describe AccountsController do

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
      2.times do
        account = FactoryGirl.create(:account)
        user.accounts << account
        accounts << account
      end
      FactoryGirl.create(:account)

      get :index
      expect(assigns(:accounts)).to eq(accounts)
    end
  end

  describe 'GET #show' do
    it 'should retrieve the specified account' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      get :show, :id => account
      expect(assigns(:account)).to eq(account)
    end
  end

  describe 'GET #new' do
    it 'should create a new instance of an account' do
      get :new
      expect(assigns(:account).class).to eq(Account)
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

    it 'should should set a flash message on success' do
      post :create, :account => valid_parameters
      expect(flash[:success]).not_to be_blank
    end

    it 'should redirect to the accounts index page on success' do
      post :create, :account => valid_parameters
      expect(response).to redirect_to(accounts_url)
    end

    it 'should set a flash error on failure' do
      post :create, :account => {}
      expect(flash[:error]).not_to be_blank
    end

    it 'should render the new page on failure' do
      post :create, :account => {}
      expect(response).to render_template('accounts/new')
    end
  end

  describe 'GET #edit' do
    it 'should retrieve the specified account' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      get :edit, :id => account
      expect(assigns(:account)).to eq(account)
    end

    it 'should not retrieve an account that belongs to another user' do
      account = FactoryGirl.create(:account)
      user = FactoryGirl.create(:user)
      user.accounts << account

      get :edit, :id => account
      expect(assigns(:account)).to be_nil
    end
  end

  describe 'PUT #update' do
    it 'should update the attributes' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      put :update, :id => account, :account => updated_parameters
      updated_parameters.each do |field, value|
        expect(assigns(:account).send(field)).to eq(value)
      end
    end

    it 'should set a flash message on success' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      put :update, :id => account, :account => updated_parameters
      expect(flash[:success]).not_to be_blank
    end

    it 'should redirect to accounts index page on success' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      put :update, :id => account, :account => updated_parameters
      expect(response).to redirect_to(accounts_url)
    end

    it 'should set a flash message on failure' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      put :update, :id => account, :account => {:name => ''}
      expect(flash[:error]).not_to be_blank
    end

    it 'should render the edit page on failure' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      put :update, :id => account, :account => {:name => ''}
      expect(response).to render_template('accounts/edit')
    end
  end

  describe 'DELETE #destroy' do
    it 'should destroy the specified account' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      delete :destroy, :id => account
      expect(user.reload.accounts).to be_blank
    end

    it 'should set a flash message on success' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      delete :destroy, :id => account
      expect(flash[:notice]).not_to be_blank
    end

    it 'should redirect to the accounts index page on success' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      delete :destroy, :id => account
      expect(response).to redirect_to(accounts_url)
    end

    it 'should set a flash message on failure' do
      account = FactoryGirl.create(:account)
      user.accounts << account
      Account.any_instance.stub(:destroy).and_return(false)

      delete :destroy, :id => account
      expect(flash[:error]).not_to be_blank
    end

    it 'should redirect to the accounts index page on failure' do
      account = FactoryGirl.create(:account)
      user.accounts << account
      Account.any_instance.stub(:destroy).and_return(false)

      delete :destroy, :id => account
      expect(response).to redirect_to(accounts_url)
    end
  end

  describe 'GET #sharing' do
    it 'should retrieve the specified account' do
      account = FactoryGirl.create(:account)
      user.accounts << account

      get :sharing, :id => account
      expect(assigns(:account)).to eq(account)
    end

    it 'should get all of the users who have access to the account, excluding the current user' do
      account = FactoryGirl.create(:account)
      account.users << user
      other_user = FactoryGirl.create(:user)
      account.users << other_user

      get :sharing, :id => account
      expect(assigns(:users)).to match_array([other_user])
    end

    it 'should get all of the current pending invitations' do
      account = FactoryGirl.create(:account)
      account.users << user
      invitation = FactoryGirl.create(:invitation, :account => account, :user => user)

      get :sharing, :id => account
      expect(assigns[:invites]).to match_array([invitation])
    end
  end
end
