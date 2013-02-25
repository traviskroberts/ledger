require 'spec_helper'

describe SiteController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user) }

  describe 'GET #index' do
    it 'should render the index if the user is not logged in' do
      get :index
      expect(response).to render_template('site/index')
    end

    it 'should redirect to the accounts index if the user is logged in' do
      controller.stub(:current_user => user)

      get :index
      expect(response).to redirect_to(accounts_url)
    end
  end

  describe 'GET #backbone' do
    context 'as authenticated user' do
      before :each do
        controller.stub(:current_user => user)
      end

      it 'should load the accounts for the current user' do
        user.should_receive(:accounts)

        get :backbone
      end

      it 'should assign the accounts to an instance variable' do
        user.stub(:accounts => 'bogus accounts')

        get :backbone
        expect(assigns(:accounts)).to be_present
      end
    end

    context 'as unauthenticated user' do
      it 'should redirect the user to login page' do
        get :backbone
        expect(response).to redirect_to(login_url)
      end
    end
  end
end
