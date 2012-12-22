require 'spec_helper'

describe UsersController do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :super_admin => true)}

  before :each do
    activate_authlogic
  end

  describe 'GET #index' do
    it 'should redirect unless current user is an admin' do
      UserSession.create(user)

      get :index
      expect(response).to redirect_to(root_url)
    end

    it 'should get a list of user accounts' do
      UserSession.create(admin)
      3.times { FactoryGirl.create(:user) }

      get :index
      expect(assigns(:users).length).to eq(4)
    end
  end

  describe 'GET #new' do
    it 'should create an instance of User' do
      get :new

      expect(assigns(:user).class).to eq(User)
    end
  end

  describe 'POST #create' do
    it 'should create a new user account' do
      post :create, :user => {:email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234'}
      expect(User.count).to eq(1)
    end

    it 'should set a flash message on success' do
      post :create, :user => {:email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234'}
      expect(flash[:success]).to be_present
    end

    it 'should log the user in on success' do
      post :create, :user => {:email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234'}
      expect(UserSession.find).to be_present
    end

    it 'should redirect to the accounts url on success' do
      post :create, :user => {:email => 'testuser@email.com', :password => 'test1234', :password_confirmation => 'test1234'}
      expect(response).to redirect_to(accounts_url)
    end

    it 'should set a flash message on failure' do
      post :create, :user => {}
      expect(flash[:error]).to be_present
    end

    it 'should render the #new template on failure' do
      post :create, :user => {}
      expect(response).to render_template('users/new')
    end
  end
end
