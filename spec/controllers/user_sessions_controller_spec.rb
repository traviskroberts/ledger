require 'spec_helper'

describe UserSessionController do
  include NullDB::RSpec::NullifiedDatabase

  let(:user) { FactoryGirl.build_stubbed(:user, :email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234') }

  describe 'GET #new' do
    it 'should create a new UserSession object' do
      get :new
      expect(assigns(:user_session).class).to eq(UserSession)
    end

    it 'should redirect an authenticated user to the homepage' do
      controller.stub(:current_user => user)

      get :new
      expect(response).to redirect_to(root_url)
    end
  end

  describe 'POST #create' do
    it 'should create a new user session record' do
      UserSession.any_instance.should_receive(:save).and_return(true)

      post :create, :user_session => {:email => user.email, :password => 'test1234'}
    end

    it 'should redirect to the root url' do
      UserSession.any_instance.stub(:save => true)

      post :create, :user_session => {:email => user.email, :password => 'test1234'}
      expect(response).to redirect_to(accounts_url)
    end

    it 'should set a flash message on failure' do
      UserSession.any_instance.stub(:save => false)

      post :create, :user_session => {:email => user.email, :password => 'boguspass'}
      expect(flash[:error]).to be_present
    end

    it 'should render the new template on failure' do
      UserSession.any_instance.stub(:save => false)

      post :create, :user_session => {:email => user.email, :password => 'boguspass'}
      expect(response).to render_template('user_session/new')
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      # this feels really dirty, but I'm not sure how to do it better
      controller.stub(:current_user => user)
      controller.stub(:current_user_session => user)
      user.stub(:destroy)
    end

    it 'should destroy the current user session' do
      user.should_receive(:destroy)

      delete :destroy
    end

    it 'should set a flash notice' do
      delete :destroy
      expect(flash[:notice]).to be_present
    end

    it 'should redirect to the login page' do
      delete :destroy
      expect(response).to redirect_to(login_url)
    end
  end

end
