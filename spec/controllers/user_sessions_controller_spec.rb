require 'spec_helper'

describe UserSessionController do

  let(:user) { FactoryGirl.create(:user, :email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234') }

  describe 'GET #new' do
    it 'should create a new UserSession object' do
      get :new
      expect(assigns(:user_session).class).to eq(UserSession)
    end
  end

  describe 'POST #create' do
    it 'should create a new user session record' do
      post :create, :user_session => {:email => user.email, :password => 'test1234'}
      expect(UserSession.find.user).to eq(user)
    end

    it 'should redirect to the root url' do
      post :create, :user_session => {:email => user.email, :password => 'test1234'}
      expect(response).to redirect_to(root_url)
    end

    it 'should set a flash message on failure' do
      post :create, :user_session => {:email => user.email, :password => 'boguspass'}
      expect(flash[:error]).to be_present
    end

    it 'should render the new template on failure' do
      post :create, :user_session => {:email => user.email, :password => 'boguspass'}
      expect(response).to render_template('user_session/new')
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      UserSession.create(user)
    end

    it 'should destroy the current user session' do
      delete :destroy
      expect(UserSession.find).to be_blank
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
